class StockAdjustmentsController < ApplicationController
  def new
    @stock_adjustment = StockAdjustment.new
    @stock_adjustment.item_id = params[:item_id] if params[:item_id].present?
    @stock_adjustment.warehouse_id = params[:warehouse_id] if params[:warehouse_id].present?
  end

  # POST /stock_adjustments
  def create
    @stock_adjustment = StockAdjustment.new(stock_adjustment_params)
    @stock_adjustment.user_id = current_user.id if user_signed_in?

    if @stock_adjustment.save
      # Redirigir a la ficha del item (donde están las pestañas)
      redirect_to item_path(@stock_adjustment.item_id), notice: 'Ajuste de stock manual registrado con éxito.'
    else
      redirect_to item_path(@stock_adjustment.item_id), alert: "Error al registrar ajuste: #{@stock_adjustment.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    @stock_adjustment = StockAdjustment.find(params[:id])
    item_id = @stock_adjustment.item_id
    @stock_adjustment.destroy
    redirect_to item_path(item_id), notice: 'Ajuste revertido y eliminado correctamente.'
  end

  private

  def stock_adjustment_params
    params.require(:stock_adjustment).permit(:warehouse_id, :item_id, :adjustment_type, :quantity, :reason, :purchase_order_line_id, :presentation_id)
  end
end
