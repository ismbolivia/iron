class AddListTypeToPriceLists < ActiveRecord::Migration[5.2]
  def change
    add_column :price_lists, :list_type, :integer, default: 0
  end
end
