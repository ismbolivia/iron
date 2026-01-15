class CreatePaymentTerms < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_terms do |t|
      t.string :name
      t.boolean :active
      t.text :note
      t.integer :company_id
      t.integer :create_uid

      t.timestamps
    end
  end
end
