class TransfersController < ApplicationController
  before_action :set_transfer, only: %i[ show edit update destroy send_transit receive ]

  # GET /transfers or /transfers.json
  def index
    @transfers = Transfer.all
  end

  # GET /transfers/1 or /transfers/1.json
  def show
  end

  # GET /transfers/new
  def new
    @transfer = Transfer.new
  end

  # GET /transfers/1/edit
  def edit
  end

  # POST /transfers or /transfers.json
  def create
    @transfer = Transfer.new(transfer_params)

    respond_to do |format|
      if @transfer.save
        format.html { redirect_to @transfer, notice: "Transfer was successfully created." }
        format.json { render :show, status: :created, location: @transfer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @transfer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transfers/1 or /transfers/1.json
  def update
    respond_to do |format|
      if @transfer.update(transfer_params)
        format.html { redirect_to @transfer, notice: "Transfer was successfully updated." }
        format.json { render :show, status: :ok, location: @transfer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @transfer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transfers/1 or /transfers/1.json
  def destroy
    @transfer.destroy

    respond_to do |format|
      format.html { redirect_to transfers_path, status: :see_other, notice: "Transfer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def send_transit
    begin
      @transfer.send_transit!
      redirect_to @transfer, notice: 'Traspaso enviado correctamente. El inventario de origen ha sido descontado.'
    rescue StandardError => e
      redirect_to @transfer, alert: "Error al enviar: #{e.message}"
    end
  end

  def receive
    begin
      @transfer.receive!
      redirect_to @transfer, notice: 'Traspaso recibido con éxito. El inventario ha sido sumado a tu sucursal.'
    rescue StandardError => e
      redirect_to @transfer, alert: "Error al recibir: #{e.message}"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transfer
      @transfer = Transfer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def transfer_params
      params.require(:transfer).permit(:origin_branch_id, :destination_branch_id, :origin_warehouse_id, :destination_warehouse_id, :date, :state, :user_id, :observations, 
        transfer_details_attributes: [:id, :item_id, :quantity, :observation, :_destroy, :purchase_order_line_id, :presentation_id])
    end
end
