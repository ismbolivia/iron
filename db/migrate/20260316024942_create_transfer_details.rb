class CreateTransferDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :transfer_details do |t|
      t.references :transfer, foreign_key: true
      t.references :item, foreign_key: true
      t.decimal :quantity
      t.string :observation

      t.timestamps
    end
  end
end
