class SettingCurrencyCompaniesController < ApplicationController
  before_action :set_setting_currency_company, only: [:show, :edit, :update, :destroy]
  before_action :set_combo_values, only: [:new, :edit, :update, :create]

  # GET /setting_currency_companies
  # GET /setting_currency_companies.json
  def index
    @setting_currency_companies = SettingCurrencyCompany.all

  end

  # GET /setting_currency_companies/1
  # GET /setting_currency_companies/1.json
  def show
  end

  # GET /setting_currency_companies/new
  def new
    @setting_currency_company = SettingCurrencyCompany.new
   if params[:company_id].present?
     @setting_currency_company.company_id = params[:company_id] 
   end      
  end

  # GET /setting_currency_companies/1/edit
  def edit
  end

  # POST /setting_currency_companies
  # POST /setting_currency_companies.json
  def create
    @setting_currency_company = SettingCurrencyCompany.new(setting_currency_company_params)
    if @setting_currency_company.save
      @company = @setting_currency_company.company
      messagess = 'successesfull'  
      else
        errores = "errors"
      end
    
  end

  # PATCH/PUT /setting_currency_companies/1
  # PATCH/PUT /setting_currency_companies/1.json
  def update
    respond_to do |format|
      if @setting_currency_company.update(setting_currency_company_params)
        format.html { redirect_to @setting_currency_company, notice: 'Setting currency company was successfully updated.' }
        format.json { render :show, status: :ok, location: @setting_currency_company }
      else
        format.html { render :edit }
        format.json { render json: @setting_currency_company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /setting_currency_companies/1
  # DELETE /setting_currency_companies/1.json
  def destroy
    @setting_currency_company.destroy
    respond_to do |format|
      format.html { redirect_to setting_currency_companies_url, notice: 'Setting currency company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
   def set_combo_values
   @companies = Company.all.order(:name)
   @currencies = Currency.all.order(:id)
   end
    # Use callbacks to share common setup or constraints between actions.
    def set_setting_currency_company
      @setting_currency_company = SettingCurrencyCompany.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def setting_currency_company_params
      params.require(:setting_currency_company).permit(:company_id, :currency_id)
    end
end
