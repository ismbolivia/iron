class CreatePurchaseOrderLinesTaxes < ActiveRecord::Migration[5.2]
  def change
    create_table :purchase_order_lines_taxes do |t|
      t.integer :purchase_order_line_id
      t.integer :tax_id

      t.timestamps
    end
  end
end
