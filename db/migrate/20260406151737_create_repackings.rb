class CreateRepackings < ActiveRecord::Migration[5.2]
  def change
    create_table :repackings do |t|
      t.references :item, foreign_key: true
      t.references :warehouse, foreign_key: true
      t.integer :origin_stock_id
      t.references :user, foreign_key: true
      t.text :notes

      t.timestamps
    end
  end
end
