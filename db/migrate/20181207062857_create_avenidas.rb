class CreateAvenidas < ActiveRecord::Migration[5.2]
  def change
    create_table :avenidas do |t|
      t.string :name
      t.integer :zona_id

      t.timestamps
    end
  end
end
