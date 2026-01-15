class CreateWarehouses < ActiveRecord::Migration[5.2]
  def change
    create_table :warehouses do |t|
      t.string :ref
      t.string :name
      t.string :description
      t.boolean :active

      t.timestamps
    end
  end
end
