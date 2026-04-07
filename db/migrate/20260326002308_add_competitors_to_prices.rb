class AddCompetitorsToPrices < ActiveRecord::Migration[5.2]
  def change
    add_column :prices, :comp_1_price, :decimal
    add_column :prices, :comp_2_price, :decimal
    add_column :prices, :comp_3_price, :decimal
  end
end
