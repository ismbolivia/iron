class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :name
      t.integer :currency_id
      t.string :code
      t.boolean :deprecated
      t.string :internal_type
      t.boolean :reconcile
      t.text :note
      t.integer :user_id
      t.integer :company_id
      t.integer :create_uid
      
      t.timestamps
    end
  end
end
