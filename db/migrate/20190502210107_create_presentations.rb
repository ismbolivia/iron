class CreatePresentations < ActiveRecord::Migration[5.2]
  def change
    create_table :presentations do |t|
      t.string :name
      t.integer :qty
      t.integer :unit_id
      t.integer :item_id

      t.timestamps
    end
  end
end
