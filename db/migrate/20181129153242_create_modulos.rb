class CreateModulos < ActiveRecord::Migration[5.2]
  def change
    create_table :modulos do |t|
      t.string :name
      t.boolean :active
      t.string :color,  null: false, default: "btn btn-icons-navbar fcbtn  fcbtn  btn-primary btn-outline btn-1c"
      t.string :icon,  null: false, default: "fas fa-gem"
      t.boolean :installed
      t.string :user_id

      t.timestamps
    end
  end
end
