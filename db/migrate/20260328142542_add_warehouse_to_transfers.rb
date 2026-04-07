class AddWarehouseToTransfers < ActiveRecord::Migration[5.2]
  def change
    add_column :transfers, :origin_warehouse_id, :integer
    add_column :transfers, :destination_warehouse_id, :integer
  end
end
