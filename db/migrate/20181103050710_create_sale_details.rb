class CreateSaleDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :sale_details do |t|
      t.integer :sale_id
      t.integer :number
      t.integer :item_id
      t.integer :qty
      t.decimal :price
      t.integer :discount
      t.integer :price_id
      t.decimal :price_sale
      t.integer :priority
      t.boolean :todiscount
      t.timestamps
    end
  end
end

