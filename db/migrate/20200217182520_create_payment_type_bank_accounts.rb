class CreatePaymentTypeBankAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_type_bank_accounts do |t|
      t.integer :payment_type_id
      t.integer :bank_account_id
      t.decimal :monto
      t.integer :sale_id
      t.integer :state
      t.integer :user_id
      t.timestamps
    end
  end
end
