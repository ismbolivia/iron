class PriceListsController < ApplicationController
  before_action :set_price_list, only: [:show, :edit, :update, :destroy, :price_list_item]
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
         
      search = Search.new(@page, PAGE_SIZE, @keywords, current_user, nil)
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
end
  # GET /price_lists/new
  def new
    @price_list = PriceList.new  
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
        format.html { redirect_to @price_list, notice: 'Price list was successfully created.' }
        format.json { render :show, status: :created, location: @price_list }
      else
        format.html { render :new }
        format.json { render json: @price_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /price_lists/1
  # PATCH/PUT /price_lists/1.json
  def update
    respond_to do |format|
      if @price_list.update(price_list_params)
        format.html { redirect_to @price_list, notice: 'Price list was successfully updated.' }
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_price_list
      @price_list = PriceList.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def price_list_params
      params.require(:price_list).permit(:name, :utilidad, :state, :date, :company_id, :user_uid, :default)
    end
end

