class AddPresentationToStocks < ActiveRecord::Migration[5.2]
  def change
    add_reference :stocks, :presentation, foreign_key: true
  end
end
