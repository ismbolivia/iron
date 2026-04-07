class AccountTransfersController < ApplicationController
  def new
    @account_transfer = AccountTransfer.new
    @account_transfer.from_account_id = params[:account_origin_id] # Carga desde dónde inicia la transferencia

    # El vendedor solo puede transferir de SUS cuentas, el Admin de TODAS.
    @accounts = current_user.is_admin? ? Account.all : current_user.accounts

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @account_transfer = AccountTransfer.new(account_transfer_params)
    @account_transfer.user_id = current_user.id

    @ban = false
    if @account_transfer.save
      @ban = true
    end

    respond_to do |format|
      format.js # Lanza create.js.erb para cerrar el modal y recargar
    end
  end

  private

  def account_transfer_params
    params.require(:account_transfer).permit(:from_account_id, :to_account_id, :from_box_id, :to_box_id, :amount, :exchange_rate, :note)
  end
end
