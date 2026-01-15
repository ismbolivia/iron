class CreatePaymentTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_types do |t|
      t.string :nethod
      t.text :description
      t.string :code

      t.timestamps
    end
  end
end
