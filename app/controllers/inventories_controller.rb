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
        # @inventory = Inventory.new(inventory_params)
     Warehouse.all.each do |warehouse|
      @inventory = Inventory.new
        last_inventory = Inventory.count
        number =  (last_inventory != nil) ? last_inventory + 1 : 1
        refe = 'I'+number.to_s
         @inventory.ref = refe
         @inventory.name_company = company.name 
         @inventory.name_warehouse = warehouse.name
         @inventory.ref_warehouse = warehouse.ref
         @inventory.save
          warehouse.items.order(:priority).to_set.each do |item|
           inventoryItem = InventoryItem.new
           inventoryItem.inventory_id = @inventory.id
           inventoryItem.item_id = item.id
           inventoryItem.code_item = item.code
           inventoryItem.name_item  = item.name
           inventoryItem.description_item = item.unit.name 
           inventoryItem.quantity_product = item.get_total_stock
            inventoryItem.price_purchase_total = item.get_precio_last*item.get_total_stock
            inventoryItem.price_sale_total = item.price_default*item.get_total_stock
            inventoryItem.variance = inventoryItem.price_sale_total - inventoryItem.price_purchase_total
            inventoryItem.user_id = current_user.id 
           # suma = suma+item.price*item.stock
           # q_total = q_total+item.stock
           inventoryItem.save
         end
           @inventory.update(sales_value:suma, quantity:q_total)
           suma = 0
           q_total = 0         
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inventory
      @inventory = Inventory.find(params[:id])
    end

    def set_index
      @page = (params[:page] || 0).to_i
      @keywords = params[:keywords]
      search = Search.new(@page, PAGE_SIZE, @keywords, current_user, nil)
      @inventories, @number_of_pages = search.inventories_by_ref
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def inventory_params
      params.require(:inventory).permit(:ref, :name_company, :name_warehouse, :ref_warehouse, :warehouse_id, :quantity, :sales_value, inventory_items_atributes: [:id, :inventory_id, :item_id, :code_item, :name_item, :description_item, :quantity_product, :price_purchase_total, :price_sale_total, :variance, :user_id, :_destroy])
    end
end
                                                                                                                                                                                                                                                                                                                                      
