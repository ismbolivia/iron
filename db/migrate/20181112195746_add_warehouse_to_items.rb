class AddWarehouseToItems < ActiveRecord::Migration[5.2]
  def change
    add_reference :items, :warehouse, foreign_key: true
  end
end
