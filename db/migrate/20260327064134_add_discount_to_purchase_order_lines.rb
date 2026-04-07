class AddDiscountToPurchaseOrderLines < ActiveRecord::Migration[5.2]
  def change
    add_column :purchase_order_lines, :discount, :decimal
  end
end
