class CreateTaxes < ActiveRecord::Migration[5.2]
  def change
    create_table :taxes do |t|
      t.string :name
      t.string :type_tax_use
      t.boolean :tax_adjustement
      t.string :amount_type
      t.boolean :active
      t.integer :company_id
      t.decimal :amount
      t.integer :account_id
      t.integer :refund_account_id
      t.text :description
      t.boolean :price_include
      t.string :include_base_amount
      t.boolean :analytic
      t.string :tax_exigible
      t.integer :cash_basis_account
      t.integer :create_uid
      t.integer :write_uid

      t.timestamps
    end
  end
end
