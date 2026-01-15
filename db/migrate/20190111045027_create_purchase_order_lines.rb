class CreatePurchaseOrderLines < ActiveRecord::Migration[5.2]
  def change
    create_table :purchase_order_lines do |t|
      t.string :name
      t.integer :item_qty
      t.date :date_planned
      t.integer :item_id
      t.decimal :price_unit , precision: 8, scale: 2
      t.float :price_tax
      t.integer :company_id
      t.integer :state
      t.integer :qty_received
      t.integer :purchase_order_id
      t.boolean :to_prices

      t.timestamps
    end
  end
end
