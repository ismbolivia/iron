class CreateProformas < ActiveRecord::Migration[5.2]
  def change
    create_table :proformas do |t|
      t.integer :number
      t.integer :sale_id

      t.timestamps
    end
  end
end
