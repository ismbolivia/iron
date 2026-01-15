class ModulosController < ApplicationController
  before_action :set_modulo, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  # GET /modulos
  # GET /modulos.json
  def index
    @modulos = Modulo.all
  end

  # GET /modulos/1
  # GET /modulos/1.json
  def show
    mymodule_users = UserModulo.where(user_id: current_user.id, modulo_id: @modulo.id)

   UserModulo.where(user_id: current_user.id).each do |module_user|
        module_user.update(state: false)
   end

    if mymodule_users.count == 0
       usermodulo = UserModulo.new
       usermodulo.user_id = current_user.id
       usermodulo.modulo_id = @modulo.id
       usermodulo.state = true
       usermodulo.save 
    else
        mymodule_users.each do |us_mod|
           us_mod.update(state: true)  
        end
        # usermodulo.update(state: true)   
    end
   
     Modulo.where.not(id: @modulo.id).each do |modulo|
       modulo.update(active: false)

     end
      @modulo.update(active:true)
       redirect_to root_url
 
  end

  # GET /modulos/new
  def new
    @modulo = Modulo.new
  end

  # GET /modulos/1/edit
  def edit
    
  end

  # POST /modulos
  # POST /modulos.json
  def create
    @modulo = Modulo.new(modulo_params)

    respond_to do |format|
      if @modulo.save
        format.html { redirect_to @modulo, notice: 'Modulo was successfully created.' }
        format.json { render :show, status: :created, location: @modulo }
      else
        format.html { render :new }
        format.json { render json: @modulo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /modulos/1
  # PATCH/PUT /modulos/1.json
  def update
    respond_to do |format|
      if @modulo.update(modulo_params)
        format.html { redirect_to @modulo, notice: 'Modulo was successfully updated.' }
        format.json { render :show, status: :ok, location: @modulo }
      else
        format.html { render :edit }
        format.json { render json: @modulo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /modulos/1
  # DELETE /modulos/1.json
  def destroy
    @modulo.destroy
    respond_to do |format|
      format.html { redirect_to modulos_url, notice: 'Modulo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_modulo
      @modulo = Modulo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def modulo_params
      params.require(:modulo).permit(:name, :active, :color, :icon, :installed, :user_id)
    end
end
