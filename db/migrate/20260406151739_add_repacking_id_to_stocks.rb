class AddRepackingIdToStocks < ActiveRecord::Migration[5.2]
  def change
    add_column :stocks, :repacking_id, :integer
  end
end
