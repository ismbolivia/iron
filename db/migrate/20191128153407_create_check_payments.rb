class CreateCheckPayments < ActiveRecord::Migration[5.2]
  def change
    create_table :check_payments do |t|
      t.integer :check_id
      t.integer :payment_type_id
      t.decimal :rode
      t.integer :state
      t.integer :sale_id
      t.integer :user_id

      t.timestamps
    end
  end
end


