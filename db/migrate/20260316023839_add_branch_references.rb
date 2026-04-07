class AddBranchReferences < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :branch, foreign_key: true, null: true
    add_reference :warehouses, :branch, foreign_key: true, null: true
    add_reference :sales, :branch, foreign_key: true, null: true
    add_reference :boxes, :branch, foreign_key: true, null: true
  end
end
