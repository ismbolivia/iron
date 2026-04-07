class AddShowBsToSales < ActiveRecord::Migration[5.2]
  def change
    add_column :sales, :show_bs, :boolean, default: false
  end
end
