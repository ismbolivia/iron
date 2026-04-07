class AddLotAndPresentationToStockAdjustments < ActiveRecord::Migration[5.2]
  def change
    add_column :stock_adjustments, :purchase_order_line_id, :integer
    add_column :stock_adjustments, :presentation_id, :integer
  end
end
