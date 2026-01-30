class PricesController < ApplicationController
  before_action :set_price, only: [:show, :edit, :update, :destroy]
  before_action :set_combo_values, only: [:new]
  load_and_authorize_resource
  # GET /prices
  # GET /prices.json
  def index
    @prices = Price.all
  end

  # GET /prices/1
  # GET /prices/1.json
  def show
  end

  # GET /prices/new
  def new
    @price = Price.new
    @item_id =  params[:item_id]
    @price.item_id = @item_id
    purchase_order_lines = Item.find(params[:item_id]).purchase_order_lines
    #.or(purchase_order_lines.where(state: 'asignado'))
    pos = purchase_order_lines.where(state: 'recibido')

    if pos.count >0
       @price.price_purchase = pos.last.price_unit
       @check = true

     else

      @check = false
    end
    
  @check
  end

  # GET /prices/1/edit
  def edit

  end
  # POST /prices
  # POST /prices.json
  def create
    @price = Price.new(price_params)
    @price.price_list_id = @price.price_list_id
      if @price.save

        @item = @price.item
        prices_last = @item.prices.where(price_list_id: @price.price_list_id)
          prices_last.each do |p|
         p.obsoleta!
       end
         @price.activo!
      end
    @pol_prices = PurchaseOrderLine.where(to_prices: true).limit(10).order(:id)
  end


  def myprice
      price = []
    if params[:price_id].present?
      price_id = params[:price_id]
      price = Price.where(id: price_id)
    end

    if !price.empty?

      result = [valid: true, id: price.first.id, price_sale: price.first.price_sale]

    else
      result = [valid: false, id: 0]
    end
    render json: result
   
  end

  # PATCH/PUT /prices/1
  # PATCH/PUT /prices/1.json
  def update     
      if @price.update(price_params)
          @price.activo!
          @item = @price.item  
      end
       @pol_prices = PurchaseOrderLine.where(to_prices: true).limit(10).order(:id)    
  end

  # DELETE /prices/1
  # DELETE /prices/1.json
  def destroy
    @item = @price.item
    @price.destroy
      
    
  end
  def priceItemAdd
    price = nil

  if params[:price_list_id].present?
      priceList = PriceList.find(params[:price_list_id])
      item = Item.find(params[:item_id])

      if item.price_lists.where(id: params[:price_list_id]).count>0

        price = PriceList.find(params[:price_list_id]).items.find(params[:item_id]).prices.last
        result = [valid: true, id: price.id, price_sale: price.price_sale, price_purchase: price.price_purchase, msm: "Precio Actual"]
        #code si precio es asignada al item mediante el preio de lista error
      else
        result = [valid: false, id: 0, price_purchase: item.get_precio_last, msm: "¡Lista de precio no definida!"]
      end


    #prices = Item.find(params[:item_id]).prices
  #  price = prices.where(price_list_id: price_list_id ).first
  else
      result = [valid: false, id: 0, price_purchase: nil,  msm: "Debe selecionar una lista de precios"]
  end


  render json: result

  end
  private
    # Use callbacks to share common setup or constraints between actions.
  def set_combo_values
    items_ids = []
    Item.find(params[:item_id]).price_lists.each do |price_list|

      items_ids.push(price_list.id) 
    end
   @price_lists = PriceList.all
  
  end
    def set_price
      @price = Price.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def price_params
      params.require(:price).permit(:name, :price_purchase, :utility, :price_sale, :active, :item_id, :price_list_id)
    end
end