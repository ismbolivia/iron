class CreateBankAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bank_accounts do |t|
      t.integer :bank_id
      t.string :number
      t.string :titular
      t.integer :currency_id

      t.timestamps
    end
  end
end
