class GlobalQuantitiesToDecimal < ActiveRecord::Migration[5.2]
  def change
    # Presentaciones (El motivo inicial del ajuste)
    change_column :presentations, :qty, :decimal, precision: 15, scale: 3
    change_column :presentations, :qty_in_parent, :decimal, precision: 15, scale: 3
    
    # Ventas y Movimientos
    change_column :sale_details, :qty, :decimal, precision: 15, scale: 3
    change_column :movements, :qty_in, :decimal, precision: 15, scale: 3
    change_column :movements, :qty_out, :decimal, precision: 15, scale: 3
    
    # Inventarios y Ajustes Manuales
    change_column :inventories, :quantity, :decimal, precision: 15, scale: 3
    change_column :inventory_items, :quantity_product, :decimal, precision: 15, scale: 3
    change_column :inventory_items, :physical_quantity, :decimal, precision: 15, scale: 3
    change_column :inventory_items, :quantity_variance, :decimal, precision: 15, scale: 3
    change_column :stock_adjustments, :quantity, :decimal, precision: 15, scale: 3
  end
end
