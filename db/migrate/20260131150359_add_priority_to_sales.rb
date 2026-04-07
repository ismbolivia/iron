class AddPriorityToSales < ActiveRecord::Migration[5.2]
  def change
    add_column :sales, :priority, :integer
  end
end
