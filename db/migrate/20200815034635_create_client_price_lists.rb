class CreateClientPriceLists < ActiveRecord::Migration[5.2]
  def change
    create_table :client_price_lists do |t|
      t.integer :client_id
      t.integer :price_list_id

      t.timestamps
    end
  end
end
