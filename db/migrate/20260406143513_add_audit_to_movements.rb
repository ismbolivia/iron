class AddAuditToMovements < ActiveRecord::Migration[5.2]
  def change
    add_column :movements, :user_id, :integer
    add_column :movements, :description, :string
  end
end
