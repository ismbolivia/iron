class UserModulosController < ApplicationController
  before_action :set_user_modulo, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /user_modulos
  # GET /user_modulos.json
  def index
    @user_modulos = UserModulo.all
  end

  # GET /user_modulos/1
  # GET /user_modulos/1.json
  def show
  end

  # GET /user_modulos/new
  def new
    @user_modulo = UserModulo.new
  end

  # GET /user_modulos/1/edit
  def edit
  end

  # POST /user_modulos
  # POST /user_modulos.json
  def create
    @user_modulo = UserModulo.new(user_modulo_params)

    respond_to do |format|
      if @user_modulo.save
        format.html { redirect_to @user_modulo, notice: 'User modulo was successfully created.' }
        format.json { render :show, status: :created, location: @user_modulo }
      else
        format.html { render :new }
        format.json { render json: @user_modulo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_modulos/1
  # PATCH/PUT /user_modulos/1.json
  def update
    respond_to do |format|
      if @user_modulo.update(user_modulo_params)
        format.html { redirect_to @user_modulo, notice: 'User modulo was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_modulo }
      else
        format.html { render :edit }
        format.json { render json: @user_modulo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_modulos/1
  # DELETE /user_modulos/1.json
  def destroy
    @user_modulo.destroy
    respond_to do |format|
      format.html { redirect_to user_modulos_url, notice: 'User modulo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_modulo
      @user_modulo = UserModulo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_modulo_params
      params.require(:user_modulo).permit(:user_id, :modulo_id, :state)
    end
end
