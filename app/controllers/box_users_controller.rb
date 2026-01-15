class BoxUsersController < ApplicationController
  before_action :set_box_user, only: [:show, :edit, :update, :destroy]

  # GET /box_users
  # GET /box_users.json
  def index
    @box_users = BoxUser.all
  end

  # GET /box_users/1
  # GET /box_users/1.json
  def show
  end

  # GET /box_users/new
  def new
    box = Box.find(params[:current_box_id])
    @box_user = box.box_users.new 
    @users = User.all

  end

  # GET /box_users/1/edit
  def edit
  end

  # POST /box_users
  # POST /box_users.json
  def create
    @box_user = BoxUser.new(box_user_params)
    @box_user.activo!

    if @box_user.save
      messagess = 'successesfull'  
      else
        errores = "errors"
      end
    @box_users = BoxUser.where(box_id: @box_user.box_id);
  end

  # PATCH/PUT /box_users/1
  # PATCH/PUT /box_users/1.json
  def update
    respond_to do |format|
      if @box_user.update(box_user_params)
        format.html { redirect_to @box_user, notice: 'Box user was successfully updated.' }
        format.json { render :show, status: :ok, location: @box_user }
      else
        format.html { render :edit }
        format.json { render json: @box_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /box_users/1
  # DELETE /box_users/1.json
  def destroy
    @box_user.desactivo!
     @box_users = BoxUser.where(box_id: @box_user.box_id);
   
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_box_user
      @box_user = BoxUser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def box_user_params
      params.require(:box_user).permit(:box_id, :user_id, :acction)
    end
end
