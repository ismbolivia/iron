class CreateBoxPurchaseOrderPayments < ActiveRecord::Migration[5.2]
  def change
    create_table :box_purchase_order_payments do |t|
      t.integer :box_id
      t.integer :purchase_order_id
      t.decimal :amount

      t.timestamps
    end
  end
end
