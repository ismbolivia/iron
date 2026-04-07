class AddParentBoxToBoxes < ActiveRecord::Migration[5.2]
  def change
    add_column :boxes, :parent_box_id, :integer
    add_index :boxes, :parent_box_id
    add_foreign_key :boxes, :boxes, column: :parent_box_id
  end
end
