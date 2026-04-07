class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :edit, :update, :destroy, :approve, :reject]
  before_action :set_combo_values, only: [:new, :edit, :update, :create]
    before_action :set_index, only: [:index, :getPaymentsRangePdf] 
  load_and_authorize_resource :except => [:pos_search]
  # GET /payments
  # GET /payments.json
   PAGE_SIZE = 10
  def index
    @page = (params[:page] || 0).to_i
    @keywords = params[:keywords]
    @pos_mode = params[:mode] == 'pos'
    
    if @pos_mode
      # Simple query to avoid duplicate rows and count errors
      @sales_with_debt = Sale.all
      @sales_with_debt = @sales_with_debt.where(user_id: current_user.id) if current_user.is_invited? || current_user.is_seller? && !current_user.is_manager?
      @sales_with_debt = @sales_with_debt.order(created_at: :desc).limit(100)
      @title = "Punto de Cobro (POS)"
    else
      # Modo normal: Historial de pagos
      search = Search.new(@page, PAGE_SIZE, @keywords, current_user, nil, nil)
      @payments, @number_of_pages = search.payments_by_num
      
      # Estadísticas para el historial
      @all_filtered_payments = Payment.joins(:sale)
      @all_filtered_payments = @all_filtered_payments.where(sales: { user_id: current_user.id }) unless current_user.is_admin?
      if @keywords.present?
        @all_filtered_payments = @all_filtered_payments.where("CAST(payments.num_payment AS TEXT) LIKE ?", "%#{@keywords}%")
      end
      @total_count = @all_filtered_payments.count
      @total_amount = @all_filtered_payments.sum(:rode)
      @title = "Pagos"
    end

    @current_sale_id = params[:current_sale_id]
    if @current_sale_id.present?
        @payments_sale = Sale.find(params[:current_sale_id]).payments
        @url_pdfs = "/payments.pdf?current_sale_id="+params[:current_sale_id].to_s
    end
    
    @data_init = params[:data_init].try(:to_date) || 30.days.ago.to_date
    @data_limit = params[:data_limit].try(:to_date) || Date.current
    @url_payment_range_pdfs = "/get_payment_range_pdf.pdf?data_init="+@data_init.to_s+"&data_limit="+(@data_limit.to_date+1).to_s+"&filter="+params[:filter].to_s
    
    @mystate = params[:state]
    @filter = params[:filter]

    respond_to do |format|
      format.html
      format.json
      format.js
      format.pdf {
        render template: 'payments/pdf/payments', 
        pdf: 'Reporte de pagos a la venta',
        title: 'Pagos',
        page_size: 'Letter',
        print_media_type: true
      }
    end 
  end

  def pos_search
    @keywords = params[:keywords]
    @sale_id = params[:sale_id]
    
    if @sale_id.present?
      @sale = Sale.find(@sale_id)
      @payments = @sale.payments.order(created_at: :desc)
      @payment = Payment.new(sale: @sale)
      @payment.num_payment = Payment.maximum(:num_payment).to_i + 1
      @methods = PaymentType.all
      @accounts = Account.where(reconcile: "true", user_id: current_user.id)
      
      if current_user.is_admin? || current_user.is_manager?
        # 🎯 Como Admin, puedes ver las cajas centrales y también las del vendedor
        cajas_vendedor = @sale.user.present? ? @sale.user.boxes.pluck(:id) : []
        @boxes = Box.where("id IN (?) OR box_type IN (?)", cajas_vendedor, [0, 3]) # Centrales (0, 3) + Vendedor
      else
        @boxes = current_user.box_users.includes(:box).map(&:box).select { |b| b.ruta? || b.sucursal_ruta? }
      end
    else
      # Optimización masiva de búsqueda:
      # - Omitimos el join a proformas porque ya no buscamos por ahí.
      # - Al solo unir 'client' (belongs_to), no hay duplicados => no se requiere 'distinct'.
      # - Añadimos .includes(:client) para evitar consultas N+1 en las vistas.
      # - Limitamos estrictamente a nivel de base de datos a 100 para no cargar todo a memoria.
      
      query = Sale.includes(:client)
      # Unimos client solo si vamos a buscar, o de forma segura
      query = query.where(sales: { user_id: current_user.id }) if current_user.is_invited? || (current_user.is_seller? && !current_user.is_manager?)
      
      if @keywords.present?
        # Utilizamos ILIKE que es nativo de Postgres y más rápido que unaccent para búsquedas básicas
        pattern = "%#{@keywords}%"
        query = query.left_joins(:client).where("clients.name ILIKE :p OR CAST(sales.number_sale AS TEXT) LIKE :p OR CAST(sales.number AS TEXT) LIKE :p", p: pattern)
      end
      
      @sales_with_debt = query.order(created_at: :desc).limit(100)
    end

    respond_to do |format|
      format.js
    end
  end
  def getPaymentsPdf
     @payments = []
       Payment.all.order(created_at: :desc).each do |payment|
        if payment.sale.user_id ==  current_user.id
          @payments.push(payment)
        end
      end
       @payments= @payments
       @url_pdfs = "/get_payment_pdf.pdf"
       @title = "Extracto de pagos"
       respond_to do |format|
        format.html
        format.json
        format.js
        format.pdf {
          render template: 'payments/pdf/payment_pdf', 
          pdf: 'Reporte de pagos a la venta',
          title: 'Pagos',
          # orientation: 'Landscape',
          page_size: 'Letter',
          print_media_type: true
        }
       end 
  end
   def getPaymentsRangePdf
     respond_to do |format|
        format.html
        format.json
        format.js
        format.pdf {
          render template: 'payments/pdf/payment_pdf_range', 
          pdf: 'Reporte de pagos a la venta',
          title: 'Pagos',
          # orientation: 'Landscape',
          page_size: 'Letter',
          print_media_type: true
        }
       end 
   end
  # GET /payments/1
  # GET /payments/1.json
  # GET /payments/1.pdf
  def show
    
  end
  def recibo
   @payment = Payment.find(params[:payment_id])
     respond_to do |format|
        format.html
        format.json
        format.pdf {
          render template: 'payments/recibo', 
          layout: 'layouts/pdf_layout.html.erb',
          pdf: 'pdf',
          title: 'Recibo',
          orientation: 'Portrait',
          page_height:  222,
          page_width:   170,
          margin:  { top: 3,
                     right: 2}                  
        }
      end
  end

  # GET /payments/new
  def new
    @payment = Payment.new
      last_payment = Payment.where(state: "confirmed").maximum('num_payment')
      # @payment_type = PaymentType.find(params[:payment_type_id])
      # @payment.payment_type_id = @payment_type.id
      # number =  (last_payment != nil) ? last_payment + 1 : 1
      # @payment.num_payment = 500
      @ban = false
      @code=  ""

    if params[:current_sale_id].present?
      if params[:payment_type_id].present?
         @payment.payment_type_id = params[:payment_type_id]
         @code = "EF"
      end
      @payment.sale_id = params[:current_sale_id]
      @sale = Sale.find( @payment.sale_id)
      @ban = true
    else
      @ban = false
    
    end
     @payment_type = PaymentType.new
     @deposit = Deposit.new
     @clients = Client.all
     @payments = Payment.all
     @bank_accounts = BankAccount.all
     @payment_types = PaymentType.all
     @sale_id = params[:current_sale_id]
  end

  # GET /payments/1/edit
  def edit
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(payment_params)

    # Validación de Seguridad para Pago Directo
    if @payment.confirmed? && !current_user.can_direct_pay?
      @payment.state = :draft # Forzar a borrador si no tiene permiso
    end
    
    # Auto-asignar Caja si el usuario tiene una asociada y no se mandó por formulario
    if @payment.box_id.blank? && current_user.box_users.any?
      @payment.box_id = current_user.box_users.first.box_id
    end

    ActiveRecord::Base.transaction do
      if @payment.save
        # Actualización de estados relacionados (bancos/cheques)
        if @payment.payment_type_bank_accounts_id.present?
          PaymentTypeBankAccount.find(@payment.payment_type_bank_accounts_id).confirmed!
        end
        if @payment.check_payment_id.present?
          CheckPayment.find(@payment.check_payment_id).confirmed!
        end

        # Actualización de la Venta vinculada
        @sale = @payment.sale
        @payment.update_column(:saldo, @sale.saldo) # Actualizamos el saldo del pago con el saldo actual de la venta

        if @sale.saldo <= 0
          @sale.update(completed: true)
          @sale.canceled! # Cambia a estado PAGADA (representado internamente por canceled)
        end
        
        @success = true
      else
        @success = false
      end
    end

    respond_to do |format|
      format.js
      format.json { render json: @payment, status: (@success ? :created : :unprocessable_entity) }
    end
  end
  
  # PATCH/PUT /payments/1
  # PATCH/PUT /payments/1.json
  def update
    respond_to do |format|
      if @payment.update(payment_params)
        format.html { redirect_to @payment, notice: 'Payment was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment }
      else
        format.html { render :edit }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    ActiveRecord::Base.transaction do
      @sale = @payment.sale
      
      # Eliminar registros relacionados si existen
      PaymentTypeBankAccount.find(@payment.payment_type_bank_accounts_id).destroy if @payment.payment_type_bank_accounts_id.present?
      CheckPayment.find(@payment.check_payment_id).destroy if @payment.check_payment_id.present?
      
      @payment.destroy
      
      # Revertir estado de la venta
      @sale.update(completed: false)
      @sale.confirmed!
    end

    respond_to do |format|
      format.js
      format.json { head :no_content }
    end
  end

  # POST /payments/1/approve
  def approve
    unless current_user.is_admin? || current_user.is_manager?
      return render json: { success: false, error: 'Unauthorized' }, status: :unauthorized
    end

    ActiveRecord::Base.transaction do
      if @payment.draft?
        @payment.confirmed!
        
        @sale = @payment.sale
        @payment.update_column(:saldo, @sale.saldo)

        if @sale.saldo <= 0
          @sale.update(completed: true)
          @sale.canceled!
        end
        @success = true
      else
        @success = false
      end
    end

    respond_to do |format|
      format.js
      format.json { render json: { success: @success } }
    end
  end

  # POST /payments/1/reject
  def reject
    unless current_user.is_admin? || current_user.is_manager?
      return render json: { success: false, error: 'Unauthorized' }, status: :unauthorized
    end

    ActiveRecord::Base.transaction do
      if @payment.draft?
        @payment.update(state: :rejected, audit_note: params[:audit_note])
        @sale = @payment.sale
        
        # Si el rechazo hace que la venta vuelva a tener deuda, revertimos su estado de Pagada
        if @sale.completed? && @sale.saldo > 0
          @sale.update(completed: false)
          @sale.confirmed!
        end
        
        @success = true
      else
        @success = false
      end
    end

    respond_to do |format|
      format.js
      format.json { render json: { success: @success } }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_index
       @data_init = params[:data_init].try(:to_date) || 30.days.ago.to_date
       @data_limit = params[:data_limit].try(:to_date) || Date.current
       @mystate =  params[:state]
       @filter = params[:filter]
       ranges = (@data_init..@data_limit)
         @payments_ranges =[]
        payments_range = Payment.where( created_at: ranges ).order(created_at: :ASC)   
      
       if current_user.is_admin?
          @payments_ranges = payments_range
       else
         payments_range.each do |pr|
          if pr.sale.user_id == current_user.id
            @payments_ranges.push(pr)
          end
         end
       end

    end
    def set_payment
      @payment = Payment.find(params[:id])
    end
     def set_combo_values
      @methods = PaymentType.all
      @accounts = Account.where(reconcile: "true", user_id: current_user.id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      params.require(:payment).permit(:sale_id, :payment_type_id, :rode, :num_payment, :discount, :account_id, :bank_account_id, :check_payment_id, :payment_type_bank_accounts_id, :payment_currency_id, :date, :box_id, :state, :audit_note)
    end
end