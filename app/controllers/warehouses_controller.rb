class WarehousesController < ApplicationController
   before_action :set_warehouse, only: [:show, :edit, :update, :destroy]
   before_action :set_combo_values, only: [:new, :edit, :update, :create]
   load_and_authorize_resource
  PAGE_SIZE = 5
  # GET /warehouses
  # GET /warehouses.json
  def index
     @page = (params[:page] || 0).to_i
    @keywords = params[:keywords]

    search = Search.new(@page, PAGE_SIZE, @keywords, current_user, nil, nil)
    @warehouses, @number_of_pages = search.warehouse_by_name
  end

  # GET /warehouses/1
  # GET /warehouses/1.json
  def show
      
          @warehouse_items = @warehouse.items.order(:id)
          duplicate_item_ids = Stock.joins(:warehouse).where(warehouses: { active: true }).where.not(warehouse_id: nil).group(:item_id).having('COUNT(DISTINCT warehouse_id) > 1').pluck(:item_id)
          @control_items = @warehouse.items.where(id: duplicate_item_ids).includes(:unit, :category, stocks: :warehouse)
          @other_warehouses = Warehouse.where.not(id: @warehouse.id).where(active: true)
          @title = "Productos del almacen "+ @warehouse.name
             respond_to do |format|
              format.html
              format.json
              format.pdf {
                render pdf: 'pdf',
                template: 'warehouses/reports/list_pdf.pdf.erb',
                        title: 'Productos',
                        orientation: 'Portrait',
                        page_size: 'Letter',
                        print_media_type: true,          
                        header: {
                        html: {
                          template: 'layouts/partials/pdf_header.html.erb',
                        }
                       }
               # footer: {
                #html: {
                 # template: 'layouts/partials/pdf_footer.html.erb',
                  #font_size: 5,
                #}
              #}
               # margin: {

               #  right: 2,
               #  left: 3 }
              }
              
          end 
  end

  # GET /warehouses/new
  def new
    @warehouse = Warehouse.new
    last_warehouse = Warehouse.count
    number =  (last_warehouse != nil) ? last_warehouse + 1 : 1
    @warehouse.ref = "A"+number.to_s
  end

  # GET /warehouses/1/edit
  def edit
  end

  # POST /warehouses
  # POST /warehouses.json
  def create
    @warehouse = Warehouse.new(warehouse_params)
    last_warehouse = Warehouse.count
     number =  (last_warehouse != nil) ? last_warehouse + 1 : 1
     @warehouse.ref = "A"+number.to_s
    respond_to do |format|
      if @warehouse.save
        format.html { redirect_to @warehouse, notice: 'Warehouse was successfully created.' }
        format.json { render :show, status: :created, location: @warehouse }
      else
        format.html { render :new }
        format.json { render json: @warehouse.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /warehouses/1
  # PATCH/PUT /warehouses/1.json
  def update
    respond_to do |format|
      if @warehouse.update(warehouse_params)
        format.html { redirect_to @warehouse, notice: 'Warehouse was successfully updated.' }
        format.json { render :show, status: :ok, location: @warehouse }
      else
        format.html { render :edit }
        format.json { render json: @warehouse.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /warehouses/1
  # DELETE /warehouses/1.json
  def destroy
    @warehouse.destroy
    respond_to do |format|
      format.html { redirect_to warehouses_url, notice: 'Warehouse was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def transfer_item
    begin
      @warehouse = Warehouse.find(params[:id])
      
      unless params[:target_warehouse_id].present?
        respond_to do |format|
          format.html { redirect_to warehouse_path(@warehouse), alert: 'Por favor seleccione un almacén de destino.' }
          format.js { render js: "alert('Por favor seleccione un almacén de destino.'); $('#transferModal-#{params[:item_id]} button[type=submit]').prop('disabled', false);" }
        end
        return
      end

      target_warehouse = Warehouse.find(params[:target_warehouse_id])
      item = Item.find(params[:item_id])

      if @warehouse && target_warehouse && item
        stocks = Stock.where(warehouse_id: @warehouse.id, item_id: item.id)
        
        if stocks.any?
          ActiveRecord::Base.transaction do
            stocks.update_all(warehouse_id: target_warehouse.id)
          end
          respond_to do |format|
            format.html { redirect_to warehouse_path(@warehouse), notice: "Producto transferido exitosamente al almacén #{target_warehouse.name}." }
            format.js {
               flash.now[:notice] = "Producto transferido exitosamente al almacén #{target_warehouse.name}."
            }
          end
        else
           respond_to_error("No se encontró stock para este producto.")
        end
      else
        respond_to_error("Error: Datos inválidos.")
      end
    rescue => e
      respond_to_error("Error procesando la solicitud: #{e.message}")
    end
  end

  private
  
  def respond_to_error(msg)
    respond_to do |format|
      format.html { redirect_to warehouse_path(@warehouse || params[:id]), alert: msg }
      format.js { render js: "alert('#{msg}');" }
    end
  end

  def set_combo_values
    @companies = Company.all.order(:name)
    @branches = Branch.all.order(:name)
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_warehouse
      @warehouse = Warehouse.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def warehouse_params
      params.require(:warehouse).permit(:ref, :name, :description, :active, :company_id, :branch_id)
    end
end
