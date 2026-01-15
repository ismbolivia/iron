class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :edit, :update, :destroy]
  before_action :set_combo_values, only: [:new, :edit, :update, :create]
    before_action :set_index, only: [:index, :getPaymentsRangePdf] 
  load_and_authorize_resource 
  # GET /payments
  # GET /payments.json
   PAGE_SIZE = 10
  def index
    @page = (params[:page] || 0).to_i
    @keywords = params[:keywords]     
     @payments_sale = []
     @current_sale_id = params[:current_sale_id]
    search = Search.new(@page, PAGE_SIZE, @keywords, current_user, nil)
    @payments, @number_of_pages = search.payments_by_num
    if @current_sale_id.present?
        @payments_sale = Sale.find(params[:current_sale_id]).payments
        @url_pdfs = "/payments.pdf?current_sale_id="+params[:current_sale_id].to_s
    end
    @url_payment_range_pdfs = "/get_payment_range_pdf.pdf?data_init="+@data_init.to_s+"&data_limit="+(@data_limit.to_date+1).to_s+"&filter="+@filter.to_s
     @data_init = params[:data_init].try(:to_date) || 30.days.ago.to_date
       @data_limit = params[:data_limit].try(:to_date) || Date.current
       @mystate =  params[:state]
       @filter = params[:filter]
    @title = "Pagos"
     respond_to do |format|
        format.html
        format.json
        format.js
        format.pdf {
          render template: 'payments/pdf/payments', 
          pdf: 'Reporte de pagos a la venta',
          title: 'Pagos',
          # orientation: 'Landscape',
          page_size: 'Letter',
          print_media_type: true,          
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
         
        }
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
          print_media_type: true,          
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
          print_media_type: true,          
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
    last_payment = Payment.all.maximum('num_payment')
    # number =  (last_payment != nil) ? last_payment + 1 : 1
    # @payment.num_payment = number
    if @payment.save 
        if @payment.payment_type_bank_accounts_id.present?
             PaymentTypeBankAccount.find(@payment.payment_type_bank_accounts_id).confirmed!    
        end   
        if @payment.check_payment_id.present?
             CheckPayment.find(@payment.check_payment_id).confirmed!    
        end 
        messagess = 'successesfull'  
      else
        errores = "errors"
    end
      @sale = @payment.sale
      @payment.saldo = @sale.saldo
      @payment.save
      if @sale.saldo <= 0
          @sale.completed = true
          @sale.cancelado!
          @sale.save
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
    @sale = @payment.sale
    if @payment.payment_type_bank_accounts_id.present?
       PaymentTypeBankAccount.find(@payment.payment_type_bank_accounts_id).destroy 
    end
    if @payment.check_payment_id.present?
       CheckPayment.find(@payment.check_payment_id).destroy 
    end
    @payment.destroy
    # addeding cotrol canceled
    @sale.completed = false
    @sale.confirmed!
    
    # respond_to do |format|
    #   format.html { redirect_to payments_url, notice: 'Payment was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
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
      params.require(:payment).permit(:sale_id, :payment_type_id, :rode, :num_payment, :discount, :account_id, :bank_account_id, :check_payment_id, :payment_type_bank_accounts_id, :payment_currency_id)
    end
end