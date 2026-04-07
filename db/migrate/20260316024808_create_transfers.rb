class CreateTransfers < ActiveRecord::Migration[5.2]
  def change
    create_table :transfers do |t|
      t.references :origin_branch, foreign_key: { to_table: :branches }
      t.references :destination_branch, foreign_key: { to_table: :branches }
      t.date :date
      t.integer :state
      t.references :user, foreign_key: true
      t.text :observations

      t.timestamps
    end
  end
end
