class InventoriesController < ApplicationController
  before_action :set_inventory, only: [:show, :edit, :update, :destroy]
  before_action :set_index, only: [:index, :view_list, :view_kamback]
  load_and_authorize_resource
  PAGE_SIZE = 10
  # GET /inventories
  # GET /inventories.json
  def index
   @list = true

  end
  def view_list
    @list = true
    render template: "/inventories/index"
  end
  def view_kamback
    @list = false
    render template: "/inventories/index"
  end

  # GET /inventories/1
  # GET /inventories/1.json
  def show
    @inventory_items = @inventory.inventory_items.to_set
    @title = "Inventario realizado a la fecha "+ @inventory.created_at.strftime("%d/%m/%Y")
       respond_to do |format|
        format.html
        format.json
        format.pdf {
          render pdf: 'pdf',
                  template: 'inventories/reports/list_pdf',
                  title: 'Inventario',
                  orientation: 'Portrait',
                  page_size: 'Letter',
                  print_media_type: true,   
                  header: {
                  html: {
                    template: 'layouts/partials/pdf_header'
                  }
                 },
                  footer: {
                     right: '[page] de [topage]',
                  html: {
                    template: 'layouts/partials/pdf_footer',
                    
                  }
                  
                },
                  margin: {                      
                    left: 15,
                     }

                
       
        }
        
       end 
  end

  # GET /inventories/new
  def new
   @inventory = Inventory.new
     last_inventory = Inventory.count
     number =  (last_inventory != nil) ? last_inventory + 1 : 1
     @refe = 'I'+number.to_s
    # @inventory = Inventory.create(ref:refe)
    # @inventory.inventory_items.build
    #  params[:inventory_id] = @inventory.id.to_s

  end

  # GET /inventories/1/edit
  def edit
  end

  # POST /inventories
  # POST /inventories.json
  def create    
    company = Company.where(mycompany: true).first
    suma = 0
    q_total = 0

    # Soporte para crear inventario de TODOS los almacenes
    Warehouse.all.each do |warehouse|
      @inventory = Inventory.new
      last_inventory = Inventory.count
      number = (last_inventory != nil) ? last_inventory + 1 : 1
      refe = 'I' + number.to_s
      
      @inventory.ref = refe
      @inventory.name_company = company.name 
      @inventory.name_warehouse = warehouse.name
      @inventory.ref_warehouse = warehouse.ref
      @inventory.warehouse_id = warehouse.id # Guardar su relacion
      @inventory.save

      # 🔍 CARGAR TODOS LOS PRODUCTOS ACTIVOS DEL SISTEMA
      Item.where(active: true).order('priority ASC').each do |item|
        inventoryItem = InventoryItem.new
        inventoryItem.inventory_id = @inventory.id
        inventoryItem.item_id = item.id
        inventoryItem.code_item = item.code
        inventoryItem.name_item  = item.name
        inventoryItem.description_item = item.unit&.name 

        # 🎯 Buscar stock puntual de ESTE almacén
        stock_item = item.stocks.find_by(warehouse_id: warehouse.id)
        current_stock = stock_item&.total.to_i

        inventoryItem.quantity_product = current_stock
        
        # Calcular los precios con seguridad para no crashear
        costo_unitario = item.get_precio_last.to_f
        precio_venta_unitario = item.price_default.to_f

        inventoryItem.price_purchase_total = costo_unitario * current_stock
        inventoryItem.price_sale_total     = precio_venta_unitario * current_stock
        inventoryItem.variance = inventoryItem.price_sale_total - inventoryItem.price_purchase_total
        inventoryItem.user_id = current_user.id 
        inventoryItem.save
      end
    end
   

    respond_to do |format|
      if @inventory.save
        format.html { redirect_to @inventory, notice: 'Inventario realizado con exito.' }
        format.json { render :show, status: :created, location: @inventory }
      else
        format.html { render :new }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inventories/1
  # PATCH/PUT /inventories/1.json
  def update
    respond_to do |format|
      if @inventory.update(inventory_params)
        format.html { redirect_to @inventory, notice: 'Inventory was successfully updated.' }
        format.json { render :show, status: :ok, location: @inventory }
      else
        format.html { render :edit }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inventories/1
  # DELETE /inventories/1.json
  def destroy
    @inventory.destroy
    respond_to do |format|
      format.html { redirect_to inventories_url, notice: 'Inventory was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # Accion para aplicar el ajuste de Auditoría automática
  def apply
    if @inventory.borrador?
      Inventory.transaction do
        @inventory.inventory_items.each do |ii|
          # calculate_variance se corre antes de guardarse si physical_quantity esta presente
          variance = ii.quantity_variance.to_i
          next if variance == 0

          qty_in  = variance > 0 ? variance.abs : 0
          qty_out = variance < 0 ? variance.abs : 0

          # 1. Crear registro en Stock
          stock = Stock.create!(
            item_id: ii.item_id,
            warehouse_id: @inventory.warehouse_id,
            qty_in: qty_in,
            qty_out: qty_out,
            state: :disponible
          )

          # 2. Crear Movimiento para trazabilidad
          Movement.create!(
            qty_in: qty_in,
            qty_out: qty_out,
            stock_id: stock.id
          )
        end
        @inventory.update!(state: :aplicado)
      end
      redirect_to @inventory, notice: 'Inventario aplicado con éxito. El stock ha sido actualizado.'
    else
      redirect_to @inventory, alert: 'Este inventario ya fue aplicado o cancelado.'
    end
  rescue => e
    redirect_to @inventory, alert: "Error al aplicar inventario: #{e.message}"
  end

  # Acción para descargar plantilla Excel (CSV)
  def download_template
    csv_data = CSV.generate(headers: true) do |csv|
      csv << ["Item_ID", "Codigo", "Producto", "Stock_Sistema", "Conteo_Real"]
      @inventory.inventory_items.each do |ii|
        csv << [ii.item_id, ii.code_item, ii.name_item, ii.quantity_product, ""]
      end
    end
    send_data csv_data, filename: "Plantilla_Inventario_#{@inventory.ref}.csv", type: 'text/csv; charset=utf-8'
  end

  # Acción para procesar la subida del Excel
  def upload_template
    if params[:file].present?
      spreadsheet = Roo::Spreadsheet.open(params[:file].path)
      header = spreadsheet.row(1)

      error_count = 0
      updated_count = 0

      Inventory.transaction do
        (2..spreadsheet.last_row).each do |i|
          row = Hash[[header, spreadsheet.row(i)].transpose]
          item_id = row["Item_ID"].to_i
          conteo_real = row["Conteo_Real"]

          next if conteo_real.blank?

          ii = @inventory.inventory_items.find_by(item_id: item_id)
          if ii
            ii.update!(physical_quantity: conteo_real.to_i)
            updated_count += 1
          else
            error_count += 1
          end
        end
      end

      flash[:notice] = "Se cargaron #{updated_count} productos desde el Excel con éxito."
      flash[:alert] = "No se encontraron #{error_count} productos en este inventario." if error_count > 0
    else
      flash[:alert] = "Por favor, sube un archivo válido."
    end
    redirect_to @inventory
  rescue => e
    redirect_to @inventory, alert: "Error procesando el Excel: #{e.message}"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inventory
      @inventory = Inventory.find(params[:id])
    end

    def set_index
      @page = (params[:page] || 0).to_i
      @keywords = params[:keywords]
      search = Search.new(@page, PAGE_SIZE, @keywords, current_user, nil, nil)
      @inventories, @number_of_pages = search.inventories_by_ref
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def inventory_params
      params.require(:inventory).permit(:ref, :name_company, :name_warehouse, :ref_warehouse, :warehouse_id, :quantity, :sales_value, inventory_items_attributes: [:id, :inventory_id, :item_id, :code_item, :name_item, :description_item, :quantity_product, :price_purchase_total, :price_sale_total, :variance, :user_id, :_destroy, :physical_quantity])
    end
end
                                                                                                                                                                                                                                                                                                                                      
