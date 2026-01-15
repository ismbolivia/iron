class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.integer :sale_id
      t.integer :payment_type_id
      t.decimal :rode
      t.integer :num_payment
      t.integer :discount
      t.integer :state
      t.decimal :saldo
      t.integer :account_id
      t.integer :bank_account_id
      t.integer :check_payment_id
      t.integer :payment_type_bank_accounts_id
      t.integer :payment_currency_id
      t.timestamps
    end
  end
end
