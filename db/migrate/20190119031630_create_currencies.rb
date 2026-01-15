class CreateCurrencies < ActiveRecord::Migration[5.2]
  def change
    create_table :currencies do |t|
      t.string :name
      t.string :symbol
      t.decimal :rounding
      t.boolean :active
      t.string :currency_unit_label
      t.string :currency_subunit_label
      t.integer :create_uid

      t.timestamps
    end
  end
end
