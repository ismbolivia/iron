class CreatePriceLists < ActiveRecord::Migration[5.2]
  def change
    create_table :price_lists do |t|
      t.string :name
      t.decimal :utilidad
      t.integer :state
      t.date :date
      t.integer :company_id
      t.integer :user_uid
      t.boolean :default
      t.timestamps
    end
  end
end
