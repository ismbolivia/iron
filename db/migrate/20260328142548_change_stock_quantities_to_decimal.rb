class ChangeStockQuantitiesToDecimal < ActiveRecord::Migration[5.2]
  def change
    change_column :stocks, :qty_in, :decimal, precision: 12, scale: 4, default: 0
    change_column :stocks, :qty_out, :decimal, precision: 12, scale: 4, default: 0
    change_column :stocks, :total, :decimal, precision: 12, scale: 4, default: 0
  end
end
