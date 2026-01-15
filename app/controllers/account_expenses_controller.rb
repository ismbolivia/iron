class AccountExpensesController < ApplicationController
  before_action :set_account_expense, only: [:show, :edit, :update, :destroy]

  # GET /account_expenses
  # GET /account_expenses.json
  def index
    @account_expenses = AccountExpense.all
  end

  # GET /account_expenses/1
  # GET /account_expenses/1.json
  def show
  end

  # GET /account_expenses/new
  def new
    @account_expense = AccountExpense.new
    @account_expense.account_id = params[:account_id]
      respond_to do |format|
        format.html
        format.json
        format.js
      end
  end

  # GET /account_expenses/1/edit
  def edit
  end

  # POST /account_expenses
  # POST /account_expenses.json
  def create
    @account_expense = AccountExpense.new(account_expense_params)
    @account = @account_expense.account
      if @account_expense.amount <= @account.total       
          @ban = true
    respond_to do |format|    
          if @account_expense.save
            format.html { redirect_to @account_expense, notice: 'Account expense was successfully created.' }
            format.json { render :show, status: :created, location: @account_expense }
            format.js
          else
            format.html { render :new }
            format.json { render json: @account_expense.errors, status: :unprocessable_entity }
            format.js
          end       
       end
        else
          @ban = false
        end
  end

  # PATCH/PUT /account_expenses/1
  # PATCH/PUT /account_expenses/1.json
  def update
    respond_to do |format|
      if @account_expense.update(account_expense_params)
        format.html { redirect_to @account_expense, notice: 'Account expense was successfully updated.' }
        format.json { render :show, status: :ok, location: @account_expense }
      else
        format.html { render :edit }
        format.json { render json: @account_expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account_expenses/1
  # DELETE /account_expenses/1.json
  def destroy
    @account_expense.destroy
    respond_to do |format|
      format.html { redirect_to account_expenses_url, notice: 'Account expense was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account_expense
      @account_expense = AccountExpense.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_expense_params
      params.require(:account_expense).permit(:account_id, :amount, :description)
    end
end
