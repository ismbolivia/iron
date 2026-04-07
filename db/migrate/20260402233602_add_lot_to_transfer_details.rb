class AddLotToTransferDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :transfer_details, :purchase_order_line_id, :integer
    add_column :transfer_details, :presentation_id, :integer
  end
end
