class CreateMovements < ActiveRecord::Migration[5.2]
  def change
    create_table :movements do |t|
      t.integer :qty_in
      t.integer :qty_out
      t.integer :sale_detail_id
      t.integer :stock_id

      t.timestamps
    end
  end
end
