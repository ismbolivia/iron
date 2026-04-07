class AddObservedFieldsToSales < ActiveRecord::Migration[5.2]
  def change
    add_column :sales, :observation_note, :text
    add_column :sales, :observed_at, :datetime
    add_column :sales, :observed_by_user_id, :integer
    add_column :sales, :resolution_note, :text
    add_index :sales, :observed_by_user_id
  end
end
