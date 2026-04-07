class AddLoteToStocks < ActiveRecord::Migration[5.2]
  def change
    add_column :stocks, :lote, :string
    add_column :stocks, :expiration_date, :date
  end
end
