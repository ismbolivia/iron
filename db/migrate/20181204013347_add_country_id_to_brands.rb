class AddCountryIdToBrands < ActiveRecord::Migration[5.2]
  def change
    add_column :brands, :country_id, :integer
  end
end
