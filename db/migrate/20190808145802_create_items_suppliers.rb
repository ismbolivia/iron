class CreateItemsSuppliers < ActiveRecord::Migration[5.2]
  def change
    create_table :items_suppliers do |t|
      t.integer :item_id
      t.integer :supplier_id
      t.integer :state

      t.timestamps
    end
  end
end
