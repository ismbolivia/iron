class CreateAccountExpenses < ActiveRecord::Migration[5.2]
  def change
    create_table :account_expenses do |t|
      t.integer :account_id
      t.decimal :amount
      t.string :description

      t.timestamps
    end
  end
end
