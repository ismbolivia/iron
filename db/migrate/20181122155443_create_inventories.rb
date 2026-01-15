class CreateInventories < ActiveRecord::Migration[5.2]
  def change
    create_table :inventories do |t|
      t.string :ref
      t.string :name_company
      t.string :name_warehouse
      t.string :ref_warehouse
      t.integer :warehouse_id
      t.integer :quantity
      t.float :sales_value

      t.timestamps
    end
  end
end
