class AvenidasController < ApplicationController
  before_action :set_avenida, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /avenidas
  # GET /avenidas.json
  def index
    @avenidas = Avenida.all
  end

  # GET /avenidas/1
  # GET /avenidas/1.json
  def show
  end

  # GET /avenidas/new
  def new
    @avenida = Avenida.new
    @avenida.zona_id = params[:zona_id]
  end

  # GET /avenidas/1/edit
  def edit
  end

  # POST /avenidas
  # POST /avenidas.json
  def create
    @avenida = Avenida.new(avenida_params)
     if @avenida.save
      message ="successfully"
     else
      error = "errors"
     end
    
  end

  # PATCH/PUT /avenidas/1
  # PATCH/PUT /avenidas/1.json
  def update
    respond_to do |format|
      if @avenida.update(avenida_params)
        format.html { redirect_to @avenida, notice: 'Avenida was successfully updated.' }
        format.json { render :show, status: :ok, location: @avenida }
      else
        format.html { render :edit }
        format.json { render json: @avenida.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /avenidas/1
  # DELETE /avenidas/1.json
  def destroy
    @avenida.destroy
    respond_to do |format|
      format.html { redirect_to avenidas_url, notice: 'Avenida was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_avenida
      @avenida = Avenida.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def avenida_params
      params.require(:avenida).permit(:name, :zona_id)
    end
end
