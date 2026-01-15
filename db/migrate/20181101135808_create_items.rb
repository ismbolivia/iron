class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :code
      t.string :name
      t.string :description
      t.references :brand, foreign_key: true
      t.references :unit, foreign_key: true
      t.references :category, foreign_key: true
      t.integer :stock
      t.integer :min_stock
      t.decimal :price, precision: 8, scale: 2
      t.decimal :cost, precision: 8, scale: 2
      t.integer :discount
      t.boolean :active
      t.integer :priority

      t.timestamps
    end
  end
end
