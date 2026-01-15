class CreateDepartamentos < ActiveRecord::Migration[5.2]
  def change
    create_table :departamentos do |t|
      t.string :name
      t.string :code
      t.integer :country_id

      t.timestamps
    end
  end
end
