class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
    before_action :set_combo_values, only: [:new, :edit, :update, :create]
    before_action :set_index, only: [:index, :items_view_list, :items_view_kamback]
    load_and_authorize_resource :except => [:available_lots]
    # load_and_authorize_resource :only => [:index, :show, :edit, :new, :destroy]
    PAGE_SIZE = 8
  # GET /items
  # GET /items.json
  def index
       @list = nil  
       @all_items = Item.left_outer_joins(:category).order("categories.name ASC, items.priority ASC")
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
    if params[:tab].present?
      render partial: "items/tabs/#{params[:tab]}", locals: { item: @item }
      return
    end

    @months = params[:months].present? ? params[:months].to_f : 6.0
    @rotation_data = PurchasesV2::IntelligenceService.analyze_rotation(nil, @months, 1, @item.id).first

    respond_to do |format|
      format.html
      format.js
    end
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
    if params[:file].present?
      Item.import(params[:file])
      redirect_to items_path, notice: "Artículos importados con éxito."
    else
      redirect_to items_path, alert: "Por favor, seleccione un archivo para importar."
    end
  rescue => e
    redirect_to items_path, alert: "Error al importar el archivo: #{e.message}"
  end
  def available_lots
    item = Item.find(params[:id])
    
    # 1. Buscamos registros de stock con saldo, filtrando por almacén si viene en la petición
    # Normalizamos el warehouse_id para evitar strings literales 'undefined' o 'null'
    warehouse_id = params[:warehouse_id].to_s.gsub(/undefined|null/i, '').presence
    
    query = item.stocks.where("COALESCE(qty_in, 0) - COALESCE(qty_out, 0) > 0")
    query = query.where(warehouse_id: warehouse_id) if warehouse_id
    
    stocks_with_balance = query.order(created_at: :asc)
    
    lots = stocks_with_balance.map do |s|
      po_line = s.purchase_order_line # Evaluamos si existe PO
      
      # Generamos un nombre de lote amigable y rastreable, asegurando contra nulos
      created_stamp = s.created_at ? s.created_at.strftime('%d%m%y') : Time.now.strftime('%d%m%y')
      lote_display = s.lote.presence || 
                     (po_line ? "OC-#{po_line.purchase_order_id}" : "SISTEMA-#{created_stamp}-#{s.id}")
      
      {
        id: po_line&.id, # Enviamos ID de PO si existe
        stock_id: s.id,
        lote: lote_display,
        qty_available: (s.qty_in.to_f - s.qty_out.to_f).round(2)
      }
    end

    # 2. Si no hay stock absoluto, permitimos crear un lote de entrada (opcional según flujo)
    if lots.empty?
      lots << { id: nil, stock_id: "", lote: "➕ INICIALIZAR LOTE NUEVO", qty_available: 0 }
    end

    # 3. Incluimos las presentaciones para que viajen en el mismo paquete
    all_presentations = item.presentations.as_json(only: [:id, :name, :qty])
    
    render json: { lots: lots, presentations: all_presentations }
  rescue => e
    # Captura general para evitar que peticiones AJAX mueran en silencio
    render json: { lots: [{ id: nil, stock_id: "", lote: "⚠️ Error al cargar: #{e.message}", qty_available: 0 }], presentations: [] }, status: :unprocessable_entity
  end

  def print_available_stocks
    @item = Item.find(params[:id])
    
    # Same logic as the view: group by lote and presentation, select only available
    raw_grouped = @item.stocks.includes(:purchase_order_line => :purchase_order)
                              .group_by { |s| [s.purchase_order_line_id || "SISTEMA-#{s.lote}", s.presentation_id] }
                              
    @available_stocks = raw_grouped.to_a.map do |lot_id, stocks|
      balance = stocks.sum(&:qty_in) - stocks.sum(&:qty_out)
      [stocks.min_by(&:created_at), balance, stocks.count]
    end.select { |group| group[1] > 0 }.sort_by { |group| group[0].created_at || Time.now }

    render layout: false
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

