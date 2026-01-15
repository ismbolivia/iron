class CreatePurchaseOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :purchase_orders do |t|
      t.string :name
      t.date :date_order
      t.integer :supplier_id
      t.integer :currency_id
      t.integer :state
      t.text :note
      t.integer :number

      t.timestamps
    end
  end
end
