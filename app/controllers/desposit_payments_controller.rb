class DespositPaymentsController < ApplicationController
  before_action :set_desposit_payment, only: [:show, :edit, :update, :destroy]

  # GET /desposit_payments
  # GET /desposit_payments.json
  def index
    @desposit_payments = DespositPayment.all
  end

  # GET /desposit_payments/1
  # GET /desposit_payments/1.json
  def show
  end

  # GET /desposit_payments/new
  def new
    @desposit_payment = DespositPayment.new
  end

  # GET /desposit_payments/1/edit
  def edit
  end

  # POST /desposit_payments
  # POST /desposit_payments.json
  def create
    @desposit_payment = DespositPayment.new(desposit_payment_params)

    respond_to do |format|
      if @desposit_payment.save
        format.html { redirect_to @desposit_payment, notice: 'Desposit payment was successfully created.' }
        format.json { render :show, status: :created, location: @desposit_payment }
      else
        format.html { render :new }
        format.json { render json: @desposit_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /desposit_payments/1
  # PATCH/PUT /desposit_payments/1.json
  def update
    respond_to do |format|
      if @desposit_payment.update(desposit_payment_params)
        format.html { redirect_to @desposit_payment, notice: 'Desposit payment was successfully updated.' }
        format.json { render :show, status: :ok, location: @desposit_payment }
      else
        format.html { render :edit }
        format.json { render json: @desposit_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /desposit_payments/1
  # DELETE /desposit_payments/1.json
  def destroy
    @desposit_payment.destroy
    respond_to do |format|
      format.html { redirect_to desposit_payments_url, notice: 'Desposit payment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_desposit_payment
      @desposit_payment = DespositPayment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def desposit_payment_params
      params.require(:desposit_payment).permit(:payment_id, :deposit_id)
    end
end
