class AddNameToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string
    add_column :users, :rol_id, :integer
    add_column :users, :initials, :string
  end
end
