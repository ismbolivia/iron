class SaleDetailsController < ApplicationController
  before_action :set_sale, only: [:new, :create, :destroy]
  load_and_authorize_resource
  def new
    @sale_details = @sale.sale_details.build
    @sale_details.item = Item.first
    @can_credit = @sale.client.line_credit_available
  end

  def create
    item_exists = false
    sale_details_current = ''
    item_id = params[:sale_details][:item_id].to_i
    sale_detail_current = ''
    @sale.sale_details.each do |detail|
      if detail.item_id == item_id
        # Ya existe el item en la factura, agregar cantidad
        item_exists = true
        @sale_detail = detail
        @saved_sale_detail = detail.id

        break
      end
    end

    if item_exists
      @sale_detail.qty += params[:sale_details][:qty].to_i
      @sale_detail.price = params[:sale_details][:price].to_f
      @sale_detail.save!
      sale_details_current =  @sale_detail 
      # code stocks minus
    else
      sale_detail = SaleDetail.new(sale_details_params)
      sale_detail.priority = Item.find(item_id).priority
      sale_detail.todiscount = Item.find(item_id).todiscount
      if @sale.sale_details.last.nil?
        sale_detail.number = 1
      else
        sale_detail.number = @sale.sale_details.last.number + 1
      end
      @sale.sale_details << sale_detail
      sale_details_current = sale_detail
        
    end
    @sale.save!
    # descuenta el almacenamiento en stocks 
    to_discount(params[:sale_details][:qty].to_i, item_id, sale_details_current.id)
    
  end

  def edit
    @sale_detail = SaleDetail.find(params[:id])
  end

  def update
  end

  def changeDiscountSaleDetails

    id = params[:sale_detail_id].to_i
    data = params[:data].to_i
     sale_detail = SaleDetail.find(id)
     sale_detail.price_sale = ((sale_detail.price*(100 - data))/100).round(2)
     sale_detail.discount = data
     sale_detail.save

    result = [valid: true, id: sale_detail.id, subtotal: sale_detail.subtotal, ps: sale_detail.price_sale, stotal_sale:sale_detail.sale.sub_total_before_devolution, stotal: sale_detail.sale.total]  
    render json: result
  end

  def destroy
    @sale_detail = SaleDetail.find(params[:id])
      movements = @sale_detail.movements
      movements.each do |movement|
      stock = Stock.find(movement.stock_id)
      stock.qty_out -= movement.qty_out
      stock.state = 'disponible'
      stock.save
      movement.destroy
     end

     @sale_detail.destroy
    respond_to do |format|
      format.js { render layout: false }
    end
  end

def to_discount(qty, item_id, sale_detail_id)
  cantidad = qty.to_i
   
  stocks =  Item.find(item_id).stocks
  mystocks = stocks.where(state: 'disponible')
  stock_current = mystocks.first

  if stock_current.total > qty
    stock_current.qty_out += qty
    stock_current.save
    Movement.create(qty_out: qty, qty_in: 0, sale_detail_id: sale_detail_id, stock_id: stock_current.id)

  elsif stock_current.total == qty
      stock_current.qty_out += qty
      stock_current.state = 'agotado' 
      stock_current.save
      Movement.create(qty_out: qty, qty_in: 0, sale_detail_id: sale_detail_id, stock_id: stock_current.id)

  elsif stock_current.total < qty
      qty_current_movemnet = stock_current.total 
      new_qty = qty - stock_current.total
      stock_current.qty_out += stock_current.total
      stock_current.state = 'agotado' 
      stock_current.save

       Movement.create(qty_out: qty_current_movemnet, qty_in: 0, sale_detail_id: sale_detail_id, stock_id: stock_current.id)   
       self.to_discount(new_qty,  item_id, sale_detail_id) 

  end
end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale
      @sale = Sale.find(params[:sale_id].to_i)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sale_details_params
      params.require(:sale_details).permit(:id, :sale_id, :item_id, :item_description, :number, :qty, :price, :discount, :price_id, :state, :price_sale, :priority, :todiscount, :_destroy)
    end
end

