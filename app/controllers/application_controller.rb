class ApplicationController < ActionController::Base

	protect_from_forgery with: :exception
    before_action :authenticate_user!
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :get_modulos_installed
    before_action :current_modulo
    before_action :get_name_company
    
    rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to root_url, :alert => exception.message }
    end
  end

  def configure_permitted_parameters
			if User.count==0		
				devise_parameter_sanitizer.permit(:sign_up,  keys: [:name, :rol_id, :avatar, :initials])
        @rol = Rol.where(permision: 6).first.id
			else
				devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :rol_id, :avatar, :initials])
         @rol = Rol.where(permision: 0).first.id
			end
		end

    def get_modulos_installed
      @modulos_intalled = Modulo.where(installed:true).order(:id)
      @modulos = Modulo.new
    end
    def get_name_company
      mycompanies = Company.where(mycompany: true).each do |company|
        @mycompany = company
      end
    end
    def current_modulo
       if user_signed_in?
        current_user_modulo = UserModulo.where(user_id: current_user.id , state: true).first
        if UserModulo.where(user_id: current_user.id , state: true).count == 0
          @current_modulo = Modulo.where(name: 'Inicio').first
          else
             @current_modulo = Modulo.find(current_user_modulo.modulo_id)
        end
       
       end
    end
end
