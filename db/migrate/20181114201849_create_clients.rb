class CreateClients < ActiveRecord::Migration[5.2]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :phone
      t.string :mobile
      t.string :email
      t.string :web_site
      t.integer :price_list_id
      t.integer :asig_a_user_id
      t.string  :nit

      t.timestamps
    end
  end
end
