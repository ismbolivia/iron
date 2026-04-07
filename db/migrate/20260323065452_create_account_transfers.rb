class CreateAccountTransfers < ActiveRecord::Migration[5.2]
  def change
    create_table :account_transfers do |t|
      t.integer :from_account_id
      t.integer :to_account_id
      t.decimal :amount, precision: 12, scale: 2
      t.decimal :exchange_rate, precision: 12, scale: 4, default: 1.0
      t.text :note
      t.integer :user_id

      t.timestamps
    end
  end
end
