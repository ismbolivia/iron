class CreateInventoryItems < ActiveRecord::Migration[5.2]
  def change
    create_table :inventory_items do |t|
      t.integer :inventory_id
      t.integer :item_id
      t.string :code_item
      t.string :name_item
      t.string :description_item
      t.integer :quantity_product
      t.float :price_purchase_total
      t.float :price_sale_total
      t.float :variance
      t.integer :user_id

      t.timestamps
    end
  end
end
