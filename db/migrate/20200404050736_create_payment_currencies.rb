class CreatePaymentCurrencies < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_currencies do |t|
      t.integer :currency_id
      t.integer :payment_type_id
      t.integer :sale_id

      t.timestamps
    end
  end
end
