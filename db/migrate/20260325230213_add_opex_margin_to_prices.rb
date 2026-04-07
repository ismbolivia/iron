class AddOpexMarginToPrices < ActiveRecord::Migration[5.2]
  def change
    add_column :prices, :opex_margin, :decimal
  end
end
