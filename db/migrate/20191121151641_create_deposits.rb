class CreateDeposits < ActiveRecord::Migration[5.2]
  def change
    create_table :deposits do |t|
      t.integer :bank_account_id
      t.integer :client_id
      t.decimal :rode
      t.string :depositante

      t.timestamps
    end
  end
end
