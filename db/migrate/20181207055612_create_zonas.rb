class CreateZonas < ActiveRecord::Migration[5.2]
  def change
    create_table :zonas do |t|
      t.string :name
      t.integer :province_id

      t.timestamps
    end
  end
end
