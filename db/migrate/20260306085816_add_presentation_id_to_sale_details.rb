class AddPresentationIdToSaleDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :sale_details, :presentation_id, :integer
  end
end
