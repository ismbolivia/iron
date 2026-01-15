class BoxPurchaseOrderPaymentsController < ApplicationController
  before_action :set_box_purchase_order_payment, only: [:show, :edit, :update, :destroy]
  before_action :set_combo, only: [:new]
  # GET /box_purchase_order_payments
  # GET /box_purchase_order_payments.json
  def index
    @box_purchase_order_payments = BoxPurchaseOrderPayment.all
  end

  # GET /box_purchase_order_payments/1
  # GET /box_purchase_order_payments/1.json
  def show
    respond_to do |format|
        format.html
        format.json
        format.js
        format.pdf {
          render template: 'box_purchase_order_payments/pdfs/ticket', 
          pdf: 'Reporte de ventas',
          title: 'Extracto de ventas',
          orientation: 'Landscape',
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

  # GET /box_purchase_order_payments/new
  def new

    @box_purchase_order_payment = BoxPurchaseOrderPayment.new
    @box_purchase_order_payment.box_id = params[:current_box_id]
    @box = Box.find(params[:current_box_id])
  end

  # GET /box_purchase_order_payments/1/edit
  def edit
  end

  # POST /box_purchase_order_payments
  # POST /box_purchase_order_payments.json
  def create
    @box_purchase_order_payment = BoxPurchaseOrderPayment.new(box_purchase_order_payment_params)

    respond_to do |format|
      if @box_purchase_order_payment.save
        BoxDetail.create(:box_id => @box_purchase_order_payment.box_id, :reason => @box_purchase_order_payment.purchase_order.getReasonTostring, :amount => -@box_purchase_order_payment.amount, :state =>1 )
          
          @box_details_rage =Box.find(@box_purchase_order_payment.box_id).box_details.order(created_at: :desc) 
        format.html { redirect_to @box_purchase_order_payment, notice: 'Pago efectuado con exito verifique en la pestaña salidas' }
        format.json { render :show, status: :created, location: @box_purchase_order_payment }
        format.js
      else
        format.html { render :new }
        format.json { render json: @box_purchase_order_payment.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PATCH/PUT /box_purchase_order_payments/1
  # PATCH/PUT /box_purchase_order_payments/1.json
  def update
    respond_to do |format|
      if @box_purchase_order_payment.update(box_purchase_order_payment_params)
        format.html { redirect_to @box_purchase_order_payment, notice: 'Box purchase order payment was successfully updated.' }
        format.json { render :show, status: :ok, location: @box_purchase_order_payment }
      else
        format.html { render :edit }
        format.json { render json: @box_purchase_order_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /box_purchase_order_payments/1
  # DELETE /box_purchase_order_payments/1.json
  def destroy
    @box_purchase_order_payment.destroy
    respond_to do |format|
      format.html { redirect_to box_purchase_order_payments_url, notice: 'Box purchase order payment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_combo
      @purchase_orders = PurchaseOrder.where(state: "confirmado").order(name: :asc) 
      
    end
    def set_box_purchase_order_payment
      @box_purchase_order_payment = BoxPurchaseOrderPayment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def box_purchase_order_payment_params
      params.require(:box_purchase_order_payment).permit(:box_id, :purchase_order_id, :amount)
    end
end
