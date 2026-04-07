class AddStockIdToStockAdjustments < ActiveRecord::Migration[5.2]
  def change
    add_column :stock_adjustments, :stock_id, :integer
  end
end
