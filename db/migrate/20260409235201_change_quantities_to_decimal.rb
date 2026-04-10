class ChangeQuantitiesToDecimal < ActiveRecord::Migration[5.2]
  def change
    # Cambio de integer a decimal para permitir unidades fraccionadas (ej: 0.5 kg)
    change_column :presentations, :qty, :decimal, precision: 15, scale: 3
    change_column :presentations, :qty_in_parent, :decimal, precision: 15, scale: 3
    change_column :devolutions, :qty, :decimal, precision: 15, scale: 3
  end
end
