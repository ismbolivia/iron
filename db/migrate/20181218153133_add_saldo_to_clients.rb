class AddSaldoToClients < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :saldo, :float
    add_column :clients, :discount, :integer
    add_column :clients, :credit_limit, :float
  end
end
