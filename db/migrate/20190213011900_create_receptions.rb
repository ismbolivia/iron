class CreateReceptions < ActiveRecord::Migration[5.2]
  def change
    create_table :receptions do |t|
      t.integer :qty_in
      t.integer :total
      t.date :fecha
      t.text :ob
      t.integer :warehouse_id
      t.integer :user_id
      t.integer :company_id
      t.integer :purchase_order_line_id

      t.timestamps
    end
  end
end
