class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :title
      t.string :job
      t.string :email
      t.string :mobile
      t.string :nit
      t.references :client, foreign_key: true

      t.timestamps
    end
  end
end
