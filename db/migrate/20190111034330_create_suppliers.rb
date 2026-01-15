class CreateSuppliers < ActiveRecord::Migration[5.2]
  def change
    create_table :suppliers do |t|
      t.string :name
      t.string :display_name
      t.integer :is_company
      t.integer :address_id
      t.string :nit
      t.integer :job_id
      t.string :phone
      t.string :mobile
      t.string :email
      t.string :web_syte
      t.text :description
      t.integer :company_id
      t.integer :create_uid
      t.integer :state

      t.timestamps
    end
  end
end
