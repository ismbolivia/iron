class PremiumSalesController < ApplicationController
  before_action :set_sale, only: [:show, :edit, :update, :destroy, :add_item, :remove_item]
  before_action :set_combo_values, only: [:new, :edit, :create, :update]
  
  load_and_authorize_resource :sale, parent: false

  def index
    @sales = Sale.where(user: current_user).order(created_at: :desc).limit(20)
  end

  def new
    last_sale = Sale.where(state: "confirmed", user: current_user).maximum('number')
    last_sale_all = Sale.where(state: "confirmed").maximum('number_sale')
    number_sale = (last_sale_all != nil) ? last_sale_all + 1 : 1
    number = (last_sale != nil) ? last_sale + 1 : 1
    
    # Create a new draft sale independently
    @sale = Sale.create(
      date: Date.current, 
      number: number, 
      state: "draft", 
      user: current_user, 
      credit_expiration: Date.current, 
      number_sale: number_sale, 
      completed: false, 
      canceled: false, 
      discount: 0
    )
    @sale.por_facturar!
    
    # Redirect to edit to start adding items in the POS view
    redirect_to edit_premium_sale_path(@sale)
  end

  def edit
    # This will render app/views/premium_sales/edit.html.erb
  end

  def add_item
    item = Item.find(params[:item_id])
    
    # Check if item already in sale
    detail = @sale.sale_details.find_by(item_id: item.id)
    if detail
      detail.qty += 1
      detail.save
    else
      # Get default price for this item
      price = item.price_default
      
      detail = @sale.sale_details.create(
        item_id: item.id,
        qty: 1,
        price: price,
        price_sale: price,
        number: (@sale.sale_details.maximum(:number) || 0) + 1
      )
    end

    # Discount stock using existing logic from SaleDetailsController if available
    # Or implement a copy here since we want total independence
    to_discount(1, item.id, detail.id) 

    render json: {
      html: render_to_string(partial: 'premium_sales/items_list', locals: { sale: @sale }),
      subtotal: @sale.sub_total_before_devolution,
      total: @sale.total,
      count: @sale.sale_details.count
    }
  end

  def remove_item
    detail = @sale.sale_details.find(params[:detail_id])
    
    # Revert stock
    movements = detail.movements
    movements.each do |movement|
      stock = Stock.find(movement.stock_id)
      stock.qty_out -= movement.qty_out
      stock.state = 'disponible'
      stock.save
      movement.destroy
    end
    
    detail.destroy
    
    render json: {
      html: render_to_string(partial: 'premium_sales/items_list', locals: { sale: @sale }),
      subtotal: @sale.sub_total_before_devolution,
      total: @sale.total,
      count: @sale.sale_details.count
    }
  end

  def to_discount(qty, item_id, sale_detail_id)
    cantidad = qty.to_i
    stocks = Item.find(item_id).stocks
    mystocks = stocks.where(state: 'disponible')
    stock_current = mystocks.first

    return if stock_current.nil?

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
      self.to_discount(new_qty, item_id, sale_detail_id) 
    end
  end

  def update
    respond_to do |format|
      if @sale.update(sale_params)
        # Finalize sale logic here if needed, or just save
        if params[:commit] == "Finalizar Venta"
           @sale.confirmed!
           @sale.discount_total = @sale.discount
           @sale.penalty = false
           format.html { redirect_to premium_sales_path, notice: 'Venta finalizada exitosamente.' }
        else
           format.html { render :edit, notice: 'Venta guardada.' }
        end
      else
        format.html { render :edit }
      end
    end
  end

  private

  def set_sale
    @sale = Sale.find(params[:id])
  end

  def set_combo_values
    @clients = Client.where(state: 1, asig_a_user_id: current_user.id).order(:name)
  end

  def sale_params
    params.require(:sale).permit(:number, :date, :client_id, :credit, :discount_total, :total, :penalty, :credit_expiration, :discount, :number_sale, :invoiced, sale_details_attributes: [:id, :sale_id, :item_id, :number, :qty, :price, :price_list_id, :_destroy])
  end
end
