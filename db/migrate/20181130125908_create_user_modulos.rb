class CreateUserModulos < ActiveRecord::Migration[5.2]
  def change
    create_table :user_modulos do |t|
      t.integer :user_id
      t.integer :modulo_id
      t.boolean :state

      t.timestamps
    end
  end
end
