class CreateStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :stocks do |t|
      t.integer :qty_in
      t.integer :qty_out
      t.integer :total
      t.integer :item_id
      t.integer :warehouse_id
      t.integer :purchase_order_line_id
      t.integer :state
      t.timestamps
    end
  end
end
