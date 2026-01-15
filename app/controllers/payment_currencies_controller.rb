class PaymentCurrenciesController < ApplicationController
  before_action :set_payment_currency, only: [:show, :edit, :update, :destroy]

  # GET /payment_currencies
  # GET /payment_currencies.json
  def index
    @payment_currencies = PaymentCurrency.all
  end

  # GET /payment_currencies/1
  # GET /payment_currencies/1.json
  def show
  end

  # GET /payment_currencies/new
  def new
    @payment_currency = PaymentCurrency.new
    @payment_currency.payment_type_id = params[:payment_type_id]
    @payment_currency.sale_id =  params[:current_sale_id]
    @currencies = Currency.all
  end

  # GET /payment_currencies/1/edit
  def edit
  end

  # POST /payment_currencies
  # POST /payment_currencies.json
  def create
    @payment_currency = PaymentCurrency.new(payment_currency_params)

  
      if @payment_currency.save
        # format.html { redirect_to @payment_currency, notice: 'Payment currency was successfully created.' }
        # format.json { render :show, status: :created, location: @payment_currency }
      else
        # format.html { render :new }
        # format.json { render json: @payment_currency.errors, status: :unprocessable_entity }

    end
  end

  # PATCH/PUT /payment_currencies/1
  # PATCH/PUT /payment_currencies/1.json
  def update
    respond_to do |format|
      if @payment_currency.update(payment_currency_params)
        format.html { redirect_to @payment_currency, notice: 'Payment currency was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment_currency }
      else
        format.html { render :edit }
        format.json { render json: @payment_currency.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_currencies/1
  # DELETE /payment_currencies/1.json
  def destroy
    @payment_currency.destroy
    respond_to do |format|
      format.html { redirect_to payment_currencies_url, notice: 'Payment currency was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_currency
      @payment_currency = PaymentCurrency.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_currency_params
      params.require(:payment_currency).permit(:currency_id, :payment_type_id, :sale_id)
    end
end
