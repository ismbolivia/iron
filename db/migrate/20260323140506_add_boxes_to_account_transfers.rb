class AddBoxesToAccountTransfers < ActiveRecord::Migration[5.2]
  def change
    add_column :account_transfers, :from_box_id, :integer
    add_column :account_transfers, :to_box_id, :integer
  end
end
