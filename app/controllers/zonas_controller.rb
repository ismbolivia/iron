class ZonasController < ApplicationController
  before_action :set_zona, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource :except => [:getAvenidas]
  # GET /zonas
  # GET /zonas.json
  def index
    @zonas = Zona.all
  end

  # GET /zonas/1
  # GET /zonas/1.json
  def show
  end

  # GET /zonas/new
  def new
    @zona = Zona.new
    @zona.province_id = params[:province_id]
  end

  # GET /zonas/1/edit
  def edit
  end
  def getAvenidas
      avenidas = []
    if params[:zona_id].present?
      avenidas = Zona.find(params[:zona_id]).avenidas
      
    end

   if !avenidas.empty?
      result = [valid: true, id: params[:zona_id], ave: avenidas]
    else
      result = [valid: false, id: params[:zona_id], ave: avenidas]
    end
    render json: result

  end
  # POST /zonas
  # POST /zonas.json
  def create
    @zona = Zona.new(zona_params)
    if @zona.save
      message = "successfully"
       else
      error = "errors"
     end 
     
  end

  # PATCH/PUT /zonas/1
  # PATCH/PUT /zonas/1.json
  def update
    respond_to do |format|
      if @zona.update(zona_params)
        format.html { redirect_to @zona, notice: 'Zona was successfully updated.' }
        format.json { render :show, status: :ok, location: @zona }
      else
        format.html { render :edit }
        format.json { render json: @zona.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /zonas/1
  # DELETE /zonas/1.json
  def destroy
    @zona.destroy
    respond_to do |format|
      format.html { redirect_to zonas_url, notice: 'Zona was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_zona
      @zona = Zona.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def zona_params
      params.require(:zona).permit(:name, :province_id)
    end
end
