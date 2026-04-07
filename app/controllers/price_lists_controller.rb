class PriceListsController < ApplicationController
  before_action :set_price_list, only: [:show, :edit, :update, :destroy, :price_list_item, :builder, :toggle_item, :toggle_category_items]
  load_and_authorize_resource :except => [:price_list_item]
  PAGE_SIZE = 5
  # GET /price_lists
  # GET /price_lists.json
  def index
    @price_lists = PriceList.all
  end
  def price_list_price

      price_list = []
      if params[:price_list_id].present?
        price_list_id = params[:price_list_id]
        price_list = PriceList.where(id: price_list_id)
      end

      if !price_list.empty?
        result = [valid: true, utility: price_list.first.utilidad ]
      else
        result = [valid: false, utility: 0 ]
      end
      render json: result
  end
  # GET /price_lists/1
  # GET /price_lists/1.json
  def show
      @page = (params[:page] || 0).to_i
      @keywords = params[:keywords]
         
      search = Search.new(@page, PAGE_SIZE, @keywords, current_user, nil, nil)
      @items, @number_of_pages = search.price_list_item_by_name(@price_list)
      @price_lists = @price_list.items.where(active: true).order(:name)

      @datas = @price_list.orderCategoryItemsPriceList

       respond_to do |format|
        format.html
        format.csv { send_data Item.all.to_csv }
        format.xls { send_data Item.all.to_csv(col_sep: "\t") }
        format.json
        format.js
        format.pdf {
          render template: 'price_lists/pdf/pdf_list', 
          pdf: 'Lista de precios',
          title: 'Lista de precios',
          # orientation: 'Landscape',
          page_size: 'Letter',
          print_media_type: true,  
          margin: {                    
                    left:   20,
                    right:  10 },         
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
          
        }

         # margin: {

         #  right: 2,
         #  left: 3 }
        }
        
       end   
  end
  
  def price_list_item
     @datas = @price_list.orderCategoryItemsPriceList
     respond_to do |format|
      format.html
      format.pdf do
        pdf_name = "Lista de Precios - #{@price_list.name.strip}"
        render template: 'price_lists/pdf/pdf_price_list_individual',
               pdf: pdf_name,
               title: pdf_name,
               page_size: 'Letter',
               print_media_type: true,
               margin: { left: 10, right: 10, top: 20, bottom: 20 },
               header: { html: { template: 'layouts/partials/pdf_header', formats: [:html] } },
               footer: { right: '[page] de [topage]', html: { template: 'layouts/partials/pdf_footer', formats: [:html] } }
      end
    end
  end
  # GET /price_lists/new
  def new
    @price_list = PriceList.new  
    @categories = Category.all.order(:name)
  end

  # GET /price_lists/1/edit
  def edit
  end

  # POST /price_lists
  # POST /price_lists.json
  def create
     @price_list = PriceList.new(price_list_params)
     @price_list.activo!
     @price_list.user_uid = current_user.id
     @price_list.company_id = @mycompany.id
     @price_list.date = Date::current

    respond_to do |format|
      if @price_list.save
        # 🔗 Vinculación masiva de los items seleccionados en el lienzo POS
        if params[:item_ids].present?
            params[:item_ids].each do |item_id|
                item = Item.find_by(id: item_id)
                next unless item

                price_purchase = item.cost.to_f
                list_utility = @price_list.utilidad.to_f # Fallback por si no viene
                price_sale = (price_purchase * (1 + list_utility / 100)).round(4)

                # Creamos el precio cumpliendo las validaciones del modelo
                Price.create!(
                    price_list_id: @price_list.id,
                    item_id: item.id,
                    price_purchase: price_purchase,
                    utility: list_utility,
                    price_sale: price_sale
                )
            end
        end

        format.html { redirect_to builder_price_list_path(@price_list), notice: 'Price list was successfully created.' }
        format.json { render :show, status: :created, location: @price_list }
      else
        @categories = Category.all.order(:name)
        format.html { render :new }
        format.json { render json: @price_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # 🚀 Retorna el fragmento HTML del tbody para lienzo en BLANCO (Creación)
  def get_category_rows
     category = Category.find(params[:category_id])
     items = category.items.where(active: true)
     html = render_to_string(partial: 'price_lists/category_tbody_new', locals: { category: category, items: items })
     render json: { success: true, html: html }
  end

  # PATCH/PUT /price_lists/1
  # PATCH/PUT /price_lists/1.json
  def update
    respond_to do |format|
      if @price_list.update(price_list_params)
        
        # 🔗 Vinculación masiva de items del Constructor POS en modo Edición
        if params[:item_ids].present?
            # 🗑️ Solo borramos los productos que el usuario QUITÓ en la interfaz
            Price.where(price_list_id: @price_list.id).where.not(item_id: params[:item_ids]).destroy_all
            
            params[:item_ids].each do |item_id|
                item = Item.find_by(id: item_id)
                next unless item

                # 💡 find_or_create_by! solo ejecutará el bloque si el producto NO EXISTÍA en la lista.
                # De esta forma, si el usuario ya modificó el precio de un producto, NO SE SOBREESCRIBE.
                Price.find_or_create_by!(price_list_id: @price_list.id, item_id: item.id) do |p|
                    p.price_purchase = item.cost.to_f
                    p.utility = @price_list.utilidad.to_f
                    p.price_sale = (item.cost.to_f * (1 + (@price_list.utilidad.to_f / 100.0))).round(4)
                    p.active = 'activo'
                end
            end
        end

        format.html { redirect_to builder_price_list_path(@price_list), notice: 'Price list was successfully updated.' }
        format.json { render :show, status: :ok, location: @price_list }
      else
        format.html { render :edit }
        format.json { render json: @price_list.errors, status: :unprocessable_entity }
      end
    end
  end
  # DELETE /price_lists/1
  # DELETE /price_lists/1.json
  def destroy
    @price_list.destroy
    respond_to do |format|
      format.html { redirect_to price_lists_url, notice: 'Price list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  def getPriceListForSale
       @price_lists = []

       PriceList.where(default: true).each do |pl|
         @price_lists += pl.items.where(active: true).order(:id)
        end
         @price_lists
       respond_to do |format|
        format.html
        format.csv { send_data Item.all.to_csv }
        format.xls { send_data Item.all.to_csv(col_sep: "\t") }
        format.json
        format.js
        format.pdf {
          render template: 'price_lists/pdf/pdf_price_list_sale', 
          pdf: 'Lista de precios',
          title: 'Lista de precios',
          # orientation: 'Landscape',
          page_size: 'Letter',
          print_media_type: true,   
          margin:  {  left:   20,
                      right:  10  },       
          header: {
          html: {
            template: 'layouts/partials/pdf_header'
          }
         },
          footer: {
          html: {
            template: 'layouts/partials/pdf_header',
          }
        }
         # margin: {

         #  right: 2,
         #  left: 3 }
        }
        
       end   
  end

  def builder
    @categories = Category.all.order(:name)
    @datas = []
    @categories.each do |cat|
      items = cat.items.where(active: true, id: @price_list.items.pluck(:id))
      @datas << { category: cat, items: items } if items.any?
    end
  end

  def toggle_item
    price = Price.find_by(price_list_id: @price_list.id, item_id: params[:item_id])
    if price
      price.destroy
      included = false
    else
      item = Item.find(params[:item_id])
      Price.create!(
        price_list_id: @price_list.id,
        item_id: item.id,
        price_purchase: item.cost.to_f,
        utility: @price_list.utilidad.to_f,
        price_sale: (item.cost.to_f * (1 + (@price_list.utilidad.to_f / 100.0))).round(4),
        active: 'activo'
      )
      included = true
    end
    render json: { success: true, included: included }
  end

  def toggle_category_items
    category = Category.find(params[:category_id])
    items = category.items.where(active: true)
    assigned_items = @price_list.items.pluck(:id)

    missing_items = items.pluck(:id) - assigned_items

    if missing_items.any?
      items.each do |item|
        Price.find_or_create_by!(price_list_id: @price_list.id, item_id: item.id) do |p|
          p.price_purchase = item.cost.to_f
          p.utility = @price_list.utilidad.to_f
          p.price_sale = (item.cost.to_f * (1 + (@price_list.utilidad.to_f / 100.0))).round(4)
          p.active = 'activo'
        end
      end
      included = true
    else
      Price.where(price_list_id: @price_list.id, item_id: items.pluck(:id)).destroy_all
      included = false
    end

    # Renderizar el fragmento de la tabla (tbody) para mandarlo por AJAX
    html = render_to_string(partial: 'price_lists/category_tbody', locals: { category: category, items: items })
    
    render json: { success: true, included: included, html: html, category_id: category.id }
  end

  # PATCH /price_lists/:id/toggle_state
  def toggle_state
    if @price_list.activo?
      @price_list.desactivo!
    else
      @price_list.activo!
    end
    render json: { success: true, state: @price_list.state }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_price_list
      @price_list = PriceList.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def price_list_params
      params.require(:price_list).permit(:name, :utilidad, :state, :status, :date, :company_id, :user_uid, :default, :list_type)
    end
end

