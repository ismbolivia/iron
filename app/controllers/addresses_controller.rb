class AddressesController < ApplicationController
   before_action :set_address, only: [:show, :edit, :update, :destroy]
   before_action :set_combo_values, only: [:new, :edit, :update, :create]
   load_and_authorize_resource
     PAGE_SIZE = 10
  # GET /addresses
  # GET /addresses.json
  def index
    @page = (params[:page] || 0).to_i
    @keywords = params[:keywords]

    search = Search.new(@page, PAGE_SIZE, @keywords)
    @addresses, @number_of_pages = search.addresses_by_calles
  end

  # GET /addresses/1
  # GET /addresses/1.json
  def show
  end

  # GET /addresses/new
  def new
    @address = Address.new
  end

  # GET /addresses/1/edit
  def edit
  end

  # POST /addresses
  # POST /addresses.json
  def create
    @address = Address.new(address_params)

      if @address.save
      messagess = 'successesfull'
      else
        errores = "errors"
      end

  end

  # PATCH/PUT /addresses/1
  # PATCH/PUT /addresses/1.json
  def update
    respond_to do |format|
      if @address.update(address_params)
        format.html { redirect_to @address, notice: 'Address was successfully updated.' }
        format.json { render :show, status: :ok, location: @address }
      else
        format.html { render :edit }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /addresses/1
  # DELETE /addresses/1.json
  def destroy
    @address.destroy
    respond_to do |format|
      format.html { redirect_to addresses_url, notice: 'Address was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
   def set_combo_values
   @countries = Country.all.order(:name)
   @departamentos = Departamento.all.order(:name)
   @provinces = Province.all.order(:name)
   @zonas = Zona.all.order(:name)
   @avenidas = Avenida.all.order(:name)

  end
    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @address = Address.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def address_params
      params.require(:address).permit(:departamento_id, :province_id, :zona_id, :avenida_id, :calles, :coordenadas, :description, :country_id)
    end
end

