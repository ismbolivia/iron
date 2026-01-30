class SaleDetailsController < ApplicationController
  before_action :set_sale, only: [:new, :create, :destroy]
  load_and_authorize_resource
  def new
    @sale_details = @sale.sale_details.build
    @sale_details.item = Item.first
    @can_credit = @sale.client.line_credit_available
  end

  def create
    ActiveRecord::Base.transaction do
      item_exists = false
      sale_details_current = nil
      item_id = params[:sale_details][:item_id].to_i

      # Optimización: búsqueda directa en lugar de iteración
      @sale_detail = @sale.sale_details.find_by(item_id: item_id)

      if @sale_detail
        # Ya existe el item en la factura, agregar cantidad
        item_exists = true
        @sale_detail.qty += params[:sale_details][:qty].to_i
        # Actualizar precio si es necesario, aunque normalmente se debería mantener o promediar, aquí se sobreescribe según lógica original
        @sale_detail.price = params[:sale_details][:price].to_f 
        @sale_detail.save!
        sale_details_current = @sale_detail
      else
        sale_detail = SaleDetail.new(sale_details_params)
        item = Item.find(item_id)
        sale_detail.priority = item.priority
        sale_detail.todiscount = item.todiscount
        
        last_detail = @sale.sale_details.last
        sale_detail.number = last_detail ? last_detail.number + 1 : 1
        
        @sale.sale_details << sale_detail
        sale_details_current = sale_detail
      end
      
      @sale.save!
      # descuenta el almacenamiento en stocks dentro de la misma transacción
      to_discount(params[:sale_details][:qty].to_i, item_id, sale_details_current.id)
    end
  end

# ... (omitted methods)

  def to_discount(qty, item_id, sale_detail_id)
    cantidad = qty.to_i
    
    # Bloqueo pesimista para evitar condiciones de carrera en inventario
    stocks = Item.find(item_id).stocks
    # Ordenar por ID o fecha para asegurar FIFO determinista y bloquear
    mystocks = stocks.where(state: 'disponible').order(:created_at).lock(true)
    stock_current = mystocks.first

    raise "Stock insuficiente e inesperado durante la transacción" unless stock_current

    if stock_current.total > qty
      stock_current.qty_out += qty
      stock_current.save!
      Movement.create!(qty_out: qty, qty_in: 0, sale_detail_id: sale_detail_id, stock_id: stock_current.id)

    elsif stock_current.total == qty
      stock_current.qty_out += qty
      stock_current.state = 'agotado' 
      stock_current.save!
      Movement.create!(qty_out: qty, qty_in: 0, sale_detail_id: sale_detail_id, stock_id: stock_current.id)

    elsif stock_current.total < qty
      qty_current_movement = stock_current.total 
      new_qty = qty - stock_current.total
      
      stock_current.qty_out += stock_current.total
      stock_current.state = 'agotado' 
      stock_current.save!

      Movement.create!(qty_out: qty_current_movement, qty_in: 0, sale_detail_id: sale_detail_id, stock_id: stock_current.id)   
      
      # Llamada recursiva segura dentro de la transacción
      to_discount(new_qty, item_id, sale_detail_id) 
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

