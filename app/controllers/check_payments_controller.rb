class CheckPaymentsController < ApplicationController
  before_action :set_check_payment, only: [:show, :edit, :update, :destroy]

  # GET /check_payments
  # GET /check_payments.json
  def index
    @check_payments = CheckPayment.all
  end

  # GET /check_payments/1
  # GET /check_payments/1.json
  def show
  end

  # GET /check_payments/new
  def new
    @check_payment = CheckPayment.new
      @check_payment.payment_type_id = params[:payment_type_id]
      @check_payment.sale_id = params[:current_sale_id]
       @check_payment.rode= Sale.find(params[:current_sale_id]).saldo
      unCheckPayments = CheckPayment.where(state: "draft", user_id: current_user.id)
      if unCheckPayments.count > 0
        unCheckPayments.destroy_all
      end
      
    @checks = Check.all
  end

  # GET /check_payments/1/edit
  def edit
  end

  # POST /check_payments
  # POST /check_payments.json
  def create
    @check_payment = CheckPayment.new(check_payment_params)
    @check_payment.user_id = current_user.id

    # respond_to do |format|
      if @check_payment.save
          @check_payment.draft!
    end
  end

  # PATCH/PUT /check_payments/1
  # PATCH/PUT /check_payments/1.json
  def update
    respond_to do |format|
      if @check_payment.update(check_payment_params)
        format.html { redirect_to @check_payment, notice: 'Check payment was successfully updated.' }
        format.json { render :show, status: :ok, location: @check_payment }
      else
        format.html { render :edit }
        format.json { render json: @check_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /check_payments/1
  # DELETE /check_payments/1.json
  def destroy
    @check_payment.destroy
    respond_to do |format|
      format.html { redirect_to check_payments_url, notice: 'Check payment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_check_payment
      @check_payment = CheckPayment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def check_payment_params
      params.require(:check_payment).permit(:check_id, :payment_type_id, :rode, :sale_id, :state, :user_id)
    end
end


