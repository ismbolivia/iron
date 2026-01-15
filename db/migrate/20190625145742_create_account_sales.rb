class CreateAccountSales < ActiveRecord::Migration[5.2]
  def change
    create_table :account_sales do |t|
      t.integer :account_id
      t.integer :sale_id
      t.decimal :amount

      t.timestamps
    end
  end
end
