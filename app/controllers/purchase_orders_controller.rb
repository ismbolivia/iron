class PurchaseOrdersController < ApplicationController
  include DraftCleaner
  include NumberGenerator
  before_action :set_purchase_order, only: [:create, :show, :edit, :update, :destroy, :confirm_reception]
  before_action :set_combo_values, only: [:new, :edit, :update, :create]
  load_and_authorize_resource
  PAGE_SIZE = 10
  # GET /purchase_orders
  # GET /purchase_orders.json
  def index
    # eliminando los pedidos de compra que no fueron confirmados
    clean_old_drafts(PurchaseOrder, :create_uid)
    unsaved_suppliers = Supplier.where(state: "draft", create_uid: current_user.id)
    unsaved_suppliers.each do |supplier|
    supplier.destroy
    end
    @page = (params[:page] || 0).to_i
    @keywords = params[:keywords]

    search = Search.new(@page, PAGE_SIZE, @keywords, current_user, nil, params[:filter])
    @purchase_orders, @number_of_pages = search.purchase_order_by_name

  end
  def getQty
    purchase_order = nil
      if params[:purchase_order_id].present?
        purchase_order_id = params[:purchase_order_id]
        
        purchase_order = PurchaseOrder.find(purchase_order_id)
      end
      if !purchase_order.nil?
        result = [valid: true, id: purchase_order.id, qty: purchase_order.saldo]
      else
        result = [valid: false, id: 0]
      end
      render json: result
    
  end
  # GET /purchase_orders/1
  # GET /purchase_orders/1.json
  def show

    @title = "Orden de compra"
    respond_to do |format|
        format.html
        format.json
        format.js
        format.pdf {
          render template: 'purchase_orders/pdfs/table_order_lines', 
          pdf: 'Orden de compra',
          title: 'Orden de compra',
          orientation: 'Portrait',
          page_size: 'Letter',
          print_media_type: true          
          
        }
       end 
  end

  # GET /purchase_orders/new
  def new  
    clean_old_drafts(PurchaseOrder, :create_uid)
    
    number = generate_next_number(PurchaseOrder)
    
    # Find a default payment term to satisfy validation, or create a temporary one if needed
    payment_term = PaymentTerm.find_by(name: "draft") || PaymentTerm.first || PaymentTerm.create(name: "draft")

    @purchase_order = PurchaseOrder.new(
      supplier_id: params[:supplier],
      state: :confirmed,
      create_uid: current_user.id,
      date_order: Date.current,
      payment_term: payment_term,
      number: number
    )
    
    @purchase_order.name = @purchase_order.getPurchaseORderNumber
    
    if @purchase_order.save
      @purchase_order.purchase_order_lines.build
      params[:purchase_order_id] = @purchase_order.id.to_s
    else
      # Handle potential validation errors gracefully, though for a draft it should be minimal
      flash[:alert] = "Error creating draft purchase order: " + @purchase_order.errors.full_messages.join(", ")
      redirect_to purchase_orders_path
    end

  end

  # GET /purchase_orders/1/edit
  def edit
    @purchase_order.name =  @purchase_order.getPurchaseORderNumber
  end

  # POST /purchase_orders
  # POST /purchase_orders.json
  def create
    @purchase_order = PurchaseOrder.new(purchase_order_params)
    @purchase_order.state = :confirmed
    respond_to do |format|
      if @purchase_order.save
        format.html { redirect_to @purchase_order, notice: 'Orden de compra creada exitosamente.' }
        format.json { render :show, status: :created, location: @purchase_order }
      else
        format.html { render :new }
        format.json { render json: @purchase_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /purchase_orders/1
  # PATCH/PUT /purchase_orders/1.json
  def update
    respond_to do |format|
      # When updating (finalizing), we transition to confirmed
      @purchase_order.state = :confirmed
      if @purchase_order.update(purchase_order_params)
        format.html { redirect_to @purchase_order, notice: 'Orden de compra actualizada exitosamente.' }
        format.json { render :show, status: :ok, location: @purchase_order }
      else
        format.html { render :edit }
        format.json { render json: @purchase_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchase_orders/1
  # DELETE /purchase_orders/1.json
  def destroy
    @purchase_order.destroy
    respond_to do |format|
      format.html { redirect_to purchase_orders_url, notice: 'Purchase order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  # Acción para ingresar el stock de Compras Locales a Almacén
  def confirm_reception
    # 1. Evitar doble ingreso
    p_order_line_ids = @purchase_order.purchase_order_lines.map(&:id)
    if Stock.where(purchase_order_line_id: p_order_line_ids).any?
      return redirect_to @purchase_order, alert: 'El stock de esta Orden de Compra ya fue ingresado a inventarios.'
    end

    # 2. Selección de Almacén por defecto
    warehouse_id = params[:warehouse_id].presence || Warehouse.first&.id

    if warehouse_id.nil?
      return redirect_to @purchase_order, alert: 'No hay ningún almacén disponible para ingresar el stock.'
    end

    begin
      ActiveRecord::Base.transaction do
        @purchase_order.purchase_order_lines.each do |line|
          next if line.item_qty.to_f <= 0

          # Crear registro de stock
          stock = Stock.create!(
            item_id: line.item_id,
            warehouse_id: warehouse_id,
            qty_in: line.item_qty.to_f,
            qty_out: 0,
            purchase_order_line_id: line.id,
            state: :disponible
          )

          # Crear movimiento para trazabilidad
          Movement.create!(
            qty_in: line.item_qty.to_f,
            qty_out: 0,
            stock_id: stock.id
          )
        end
        @purchase_order.update!(state: 'confirmed') # Marcar cerrada
      end
      redirect_to @purchase_order, notice: '📦 Stock de Compra Local ingresado correctamente a inventarios.'
    rescue => e
      redirect_to @purchase_order, alert: 'Error al ingresar stock: ' + e.message
    end
  end

    def set_purchase_order
      @purchase_order = PurchaseOrder.find(params[:id])
    end
def set_combo_values
   @suppliers = Supplier.where(state: 'confirmed').order(:name)
   @payment_terms = PaymentTerm.where(active: true).order(:name)
end
    # Never trust parameters from the scary internet, only allow the white list through.
    def purchase_order_params
      params.require(:purchase_order).permit(:name, :date_order, :supplier_id, :currency_id, :state, :note, :number, :origen, :date_aroved, :date_planned, :amount_untaxed, :amount_tax, :amount_total, :payment_term_id, :create_uid, :company_id, purchase_order_lines_attributes:[:id, :name, :item_qty, :date_planned, :item_id, :price_unit, :discount, :price_tax, :company_id, :state, :qty_received, :purchase_order_id, :_destroy]  )
    end
end