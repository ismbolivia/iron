class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
    before_action :set_combo_values, only: [:new, :edit, :update, :create]
    before_action :set_index, only: [:index, :items_view_list, :items_view_kamback]
    load_and_authorize_resource
    # load_and_authorize_resource :only => [:index, :show, :edit, :new, :destroy]
    PAGE_SIZE = 8
  # GET /items
  # GET /items.json
  def index
       @list = nil  
       @all_items =Item.all.order(:id)
       respond_to do |format|
        format.html
        format.csv { send_data Item.all.to_csv }
        format.xls { send_data Item.all.to_csv(col_sep: "\t") }
        format.json
        format.pdf {
          render pdf: 'pdf',
                  template: 'items/pdf',
                  title: 'Productos',
                  orientation: 'Portrait',
                  page_size: 'Letter',
                  print_media_type: true,          
                  header: {
                  html: {
                    template: 'layouts/partials/pdf_header',
                  }
                 }
                 
         # footer: {
          #html: {
           # template: 'layouts/partials/pdf_header',
            #font_size: 5,
          #}
        #}
         # margin: {

         #  right: 2,
         #  left: 3 }
        }
        
       end       
  end
  
  def new_pdf
    
  end
  def items_view_list  
      @list = true
    render template: "/items/index"
  end
  def items_view_kamback  
      @list = false
    render template: "/items/index"
  end
  # GET /items/1
  # GET /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)
    @item.active = true 
    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Articulo(Producto) Creado.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to items_url, notice: 'Ariticulo(Producto) Actualizado.' }
        format.json { render :show, status: :ok, location: @item }
         format.js { render :action => 'update.js.erb'}
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
        format.js { render :action => 'update.js.erb'}
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Articulo(Producto) Eliminado.' }
      format.json { head :no_content }
    end
  end
def import
  Item.import(params[:file])
  redirect_to root_url, notice: "Products imported."
end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end
  def set_combo_values
   @units = Unit.all.order(:name)
   @categories = Category.all.order(:name)
   @warehouses = Warehouse.all.order(:name)
  end
  def set_index
      @page = (params[:page] || 0).to_i
      @keywords = params[:keywords]
      search = Search.new(@page, PAGE_SIZE, @keywords, current_user, nil, nil)
      @items, @number_of_pages = search.items_by_description
  end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:code, :name, :description, :brand_id, :unit_id, :category_id, :stock, :min_stock, :price, :cost, :active, :warehouse_id,:image, :discount, :todiscount, :sold, :bought, :priority)
    end
    def get_items
      @all_items =Item.all

    end
end

