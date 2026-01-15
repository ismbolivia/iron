class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy]
  before_action :set_combo_values, only: [:new, :edit, :update, :create]
  load_and_authorize_resource
  # GET /accounts
  # GET /accounts.json
  def index
    if current_user.is_admin?
    @accounts = Account.all
    else
      @accounts = current_user.accounts
    end
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show

  end

  # GET /accounts/new
  def new
    @account = Account.new
      
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = Account.new(account_params)
    @account.create_uid = current_user.id
    @account.company_id = @mycompany.id
    last_account = Account.all.maximum('code')
    code =  (last_account != nil) ? last_account.to_i + 1 : 1
    @account.code = code

    respond_to do |format|
      if @account.save
        format.html { redirect_to @account, notice: 'Account was successfully created.' }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to @account, notice: 'Account was successfully updated.' }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url, notice: 'Account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  def currency
    account = []
     if params[:account_id].present?
       account_id = params[:account_id]     
       account = Account.find(account_id)
        # result = [valid: true, id: account.id, symbol: account.currency.symbol]
     end

        if !account.nil?
        result = [valid: true, id: account.id, symbol: account.currency.symbol]
        else
        result = [valid: false, id: 0, symbol: '']
        end
   
     render json: result
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end
    def set_combo_values
    @currencies = Currency.where(active: true).order(:name)
    @users = User.all.order(:name)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:name, :currency_id, :code, :deprecated, :internal_type, :reconcile, :note, :company_id, :create_uid, :user_id)
    end
end
