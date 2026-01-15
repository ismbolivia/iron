class CreateSales < ActiveRecord::Migration[5.2]
  def change
    create_table :sales do |t|
      t.integer :number
      t.date :date
      t.integer :state
      t.integer :user_id
      t.integer :discount
      t.boolean :credit
      t.integer :discount_total
      t.date :credit_expiration
      t.boolean :penalty
      t.integer :number_sale
      t.integer :invoiced
      t.boolean :canceled
      t.boolean :completed
      t.decimal :total
      t.timestamps
    end
  end
end
