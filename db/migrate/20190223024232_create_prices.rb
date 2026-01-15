class CreatePrices < ActiveRecord::Migration[5.2]
  def change
    create_table :prices do |t|
      t.string :name
      t.decimal :price_purchase
      t.decimal :utility
      t.decimal :price_sale
      t.integer :active
      t.integer :item_id
      t.integer :price_list_id

      t.timestamps
    end
  end
end
