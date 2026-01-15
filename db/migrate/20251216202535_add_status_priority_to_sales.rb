class AddStatusPriorityToSales < ActiveRecord::Migration[5.2]
  def change
    add_column :sales, :status_priority, :integer, default: 99, index: true
  end
end
