class AddProfileToContacts < ActiveRecord::Migration[5.2]
  def change
    add_column :contacts, :profile, :string
  end
end
