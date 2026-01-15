class CreateDespositPayments < ActiveRecord::Migration[5.2]
  def change
    create_table :desposit_payments do |t|
      t.string :payment_id
      t.string :deposit_id

      t.timestamps
    end
  end
end
