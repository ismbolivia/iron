class AddHierarchyToPresentations < ActiveRecord::Migration[5.2]
  def change
    add_column :presentations, :parent_id, :integer
    add_column :presentations, :qty_in_parent, :integer
  end
end
