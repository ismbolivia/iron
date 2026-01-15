class CreateBoxUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :box_users do |t|
      t.integer :box_id
      t.integer :user_id
      t.integer :acction

      t.timestamps
    end
  end
end
