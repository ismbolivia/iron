class AddBoxIdToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :box_id, :integer
  end
end
