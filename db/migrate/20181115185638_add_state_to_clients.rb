class AddStateToClients < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :state, :integer
    add_column :clients, :user_id, :integer
  end
end
