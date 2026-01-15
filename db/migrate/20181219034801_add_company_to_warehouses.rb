class AddCompanyToWarehouses < ActiveRecord::Migration[5.2]
  def change
    add_column :warehouses, :company_id, :integer
  end
end
