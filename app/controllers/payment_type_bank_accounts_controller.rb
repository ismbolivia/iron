class PaymentTypeBankAccountsController < ApplicationController
  before_action :set_payment_type_bank_account, only: [:show, :edit, :update, :destroy]
  # GET /payment_type_bank_accounts
  # GET /payment_type_bank_accounts.json
  def index
   
    @payment_type_bank_accounts = PaymentTypeBankAccount.all
  end

  # GET /payment_type_bank_accounts/1
  # GET /payment_type_bank_accounts/1.json
  def show
  end

  # GET /payment_type_bank_accounts/new
  def new
    unPayment_type_bank_accounts = PaymentTypeBankAccount.where(state: "draft", user_id: current_user.id)
    unPayment_type_bank_accounts.destroy_all

    @current_sale_id = params[:current_sale_id]
    @payment_type_id = params[:payment_type_id]
    @payment_type_bank_account = PaymentTypeBankAccount.new
    @payment_type_bank_account.payment_type_id= @payment_type_id 
    @payment_type_bank_account.sale_id = @current_sale_id
    @payment_type_bank_account.monto= Sale.find( @current_sale_id).total_final
    @bank_accounts = BankAccount.all

  end

  # GET /payment_type_bank_accounts/1/edit
  def edit
  end

  # POST /payment_type_bank_accounts
  # POST /payment_type_bank_accounts.json
  def create
     @payment_type_bank_account = PaymentTypeBankAccount.new(payment_type_bank_account_params)      
      @payment_type_bank_account.user_id = current_user.id   
       if @payment_type_bank_account.save
        @payment_type_bank_account.draft!
          success = "to stored"
       end
        
  end

  # PATCH/PUT /payment_type_bank_accounts/1
  # PATCH/PUT /payment_type_bank_accounts/1.json
  def update
    respond_to do |format|
      if @payment_type_bank_account.update(payment_type_bank_account_params)
        format.html { redirect_to @payment_type_bank_account, notice: 'Payment type bank account was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment_type_bank_account }
      else
        format.html { render :edit }
        format.json { render json: @payment_type_bank_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_type_bank_accounts/1
  # DELETE /payment_type_bank_accounts/1.json
  def destroy
    @payment_type_bank_account.destroy
    respond_to do |format|
      format.html { redirect_to payment_type_bank_accounts_url, notice: 'Payment type bank account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_type_bank_account
      @payment_type_bank_account = PaymentTypeBankAccount.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_type_bank_account_params
      params.require(:payment_type_bank_account).permit(:payment_type_id, :bank_account_id, :monto, :sale_id, :state, :user_id)
    end
end
