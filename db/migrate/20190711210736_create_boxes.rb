class CreateBoxes < ActiveRecord::Migration[5.2]
  def change
    create_table :boxes do |t|
      t.string :user_id
      t.string :name
      t.text :description
      t.string :currency_id
      t.integer :active

      t.timestamps
    end
  end
end
