class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.integer :departamento_id
      t.integer :province_id
      t.integer :zona_id
      t.integer :avenida_id
      t.string :calles
      t.float :coordenadas
      t.string :description
      t.integer :country_id

      t.timestamps
    end
  end
end
