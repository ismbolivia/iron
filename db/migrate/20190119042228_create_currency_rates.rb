class CreateCurrencyRates < ActiveRecord::Migration[5.2]
  def change
    create_table :currency_rates do |t|
      t.date :name
      t.decimal :rate
      t.integer :currency_id
      t.integer :company_id
      t.integer :create_uid
      t.integer :currency_ref
      t.boolean :state

      t.timestamps
    end
  end
end
