class ChangeProcurementQuantitiesToDecimal < ActiveRecord::Migration[5.2]
  def change
    change_column :purchase_order_lines, :item_qty, :decimal, precision: 12, scale: 4, default: 0
    change_column :purchase_order_lines, :qty_received, :decimal, precision: 12, scale: 4, default: 0
    change_column :receptions, :qty_in, :decimal, precision: 12, scale: 4, default: 0
  end
end
