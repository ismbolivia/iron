class UsersController < ApplicationController
	 PAGE_SIZE = 10

	 load_and_authorize_resource :only => [:index, :show, :edit, :new, :destroy]
	 before_action :set_combo_values, only: [:new, :edit, :update, :create]
	 load_and_authorize_resource
	def index
			
		@page = (params[:page] || 0).to_i
  		@keywords = params[:keywords]

  		search = Search.new(@page, PAGE_SIZE, @keywords, current_user, nil, nil)
  		@users, @number_of_pages = search.users_by_description
		
	end
	def edit
		@user = User.find(params[:id])
	end
	def destroy
		
	end
	def show
		@user = User.find(params[:id])
	end
	def update
		@user = User.find(params[:id])

	  	@user.update(user_params)
	  
		

		redirect_to users_url 	
	 # if @user.update(params[:permission])
  #       format.html { redirect_to @user, notice: 'User was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @user }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
    
	end

	  private
	   def set_combo_values
	   @rols = Rol.all.order(:name)
	   @branches = Branch.all.order(:name)
	  end

	def user_params
      params.require(:user).permit(:name, :rol_id, :initials, :avatar, :branch_id, :phone, :mobile, :commission_rate)
    end
end
