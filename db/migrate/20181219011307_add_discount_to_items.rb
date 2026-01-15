class AddDiscountToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :todiscount, :boolean
    add_column :items, :sold, :boolean
    add_column :items, :bought, :boolean
  end
end
