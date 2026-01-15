class CurrencyRatesController < ApplicationController
  before_action :set_currency_rate, only: [:show, :edit, :update, :destroy]
  before_action :set_combo_values, only: [:new, :edit, :update, :create]
  load_and_authorize_resource
  # GET /currency_rates
  # GET /currency_rates.json
  def index
    @currency_rates = CurrencyRate.all
  end

  # GET /currency_rates/1
  # GET /currency_rates/1.json
  def show
  end

  # GET /currency_rates/new
  def new
    @currency_rate = CurrencyRate.new
    currency_id = params[:currency_id]
    @currency_rate.currency_id = currency_id 
  end

  # GET /currency_rates/1/edit
  def edit
    @currency_rate.update(:state => false)
    @currency = Currency.find(@currency_rate.currency_id)
  end

  # POST /currency_rates
  # POST /currency_rates.json
  def create
    @currency_rate = CurrencyRate.new(currency_rate_params)
    @currency_rate.name = Date::current
    @currency_rate.currency.disability
    @currency_rate.state =  true      
    if @currency_rate.save
       @currency = Currency.find(@currency_rate.currency_id)      
      messagess = 'successesfull'  
      else
        errores = "errors"
      end
  end

  # PATCH/PUT /currency_rates/1
  # PATCH/PUT /currency_rates/1.json
  def update
    respond_to do |format|
      if @currency_rate.update(currency_rate_params)
        format.html { redirect_to @currency_rate, notice: 'Currency rate was successfully updated.' }
        format.json { render :show, status: :ok, location: @currency_rate }
      else
        format.html { render :edit }
        format.json { render json: @currency_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /currency_rates/1
  # DELETE /currency_rates/1.json
  def destroy
    @currency = @currency_rate.currency 
    @currency_rate.destroy
    respond_to do |format|
      format.js { render layout: false }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_currency_rate
      @currency_rate = CurrencyRate.find(params[:id])
    end
    def set_combo_values
      @currencies = Currency.all.order(:name)     
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def currency_rate_params
      params.require(:currency_rate).permit(:name, :rate, :currency_id, :company_id, :create_uid, :currency_ref, :state)
    end
end
