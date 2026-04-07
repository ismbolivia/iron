class AddCommissionPaidToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :commission_paid, :boolean, default: false
  end
end
