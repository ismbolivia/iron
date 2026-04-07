class AddPricingLogicToImportaciones < ActiveRecord::Migration[5.2]
  def change
    add_column :importaciones, :pricing_logic, :string
  end
end
