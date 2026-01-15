class AccountSalesController < ApplicationController
  before_action :set_account_sale, only: [:show, :edit, :update, :destroy]

  # GET /account_sales
  # GET /account_sales.json
  def index
    @account_sales = AccountSale.all
  end

  # GET /account_sales/1
  # GET /account_sales/1.json
  def show
  end

  # GET /account_sales/new
  def new
    @account_sale = AccountSale.new
  end

  # GET /account_sales/1/edit
  def edit
  end

  # POST /account_sales
  # POST /account_sales.json
  def create
    @account_sale = AccountSale.new(account_sale_params)

    respond_to do |format|
      if @account_sale.save
        format.html { redirect_to @account_sale, notice: 'Account sale was successfully created.' }
        format.json { render :show, status: :created, location: @account_sale }
      else
        format.html { render :new }
        format.json { render json: @account_sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account_sales/1
  # PATCH/PUT /account_sales/1.json
  def update
    respond_to do |format|
      if @account_sale.update(account_sale_params)
        format.html { redirect_to @account_sale, notice: 'Account sale was successfully updated.' }
        format.json { render :show, status: :ok, location: @account_sale }
      else
        format.html { render :edit }
        format.json { render json: @account_sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account_sales/1
  # DELETE /account_sales/1.json
  def destroy
    @account_sale.destroy
    respond_to do |format|
      format.html { redirect_to account_sales_url, notice: 'Account sale was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account_sale
      @account_sale = AccountSale.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_sale_params
      params.require(:account_sale).permit(:account_id, :sale_id, :amount)
    end
end
