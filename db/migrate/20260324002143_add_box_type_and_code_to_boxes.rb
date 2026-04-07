class AddBoxTypeAndCodeToBoxes < ActiveRecord::Migration[5.2]
  def change
    add_column :boxes, :box_type, :integer, default: 0
    add_column :boxes, :code, :string
  end
end
