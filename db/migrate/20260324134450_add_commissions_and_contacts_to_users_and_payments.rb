class AddCommissionsAndContactsToUsersAndPayments < ActiveRecord::Migration[5.2]
  def change
    # Campos para Comisiones
    add_column :users, :commission_rate, :decimal, default: 0.0, precision: 10, scale: 2
    add_column :payments, :commission_amount, :decimal, default: 0.0, precision: 12, scale: 2

    # Campos de Contacto para el Usuario
    add_column :users, :phone, :string
    add_column :users, :mobile, :string
  end
end
