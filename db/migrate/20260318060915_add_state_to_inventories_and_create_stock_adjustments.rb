class AddStateToInventoriesAndCreateStockAdjustments < ActiveRecord::Migration[5.2]
  def change
    # 1. Columnas para Auditorías Automáticas
    add_column :inventories, :state, :integer, default: 0
    add_column :inventory_items, :physical_quantity, :integer
    add_column :inventory_items, :quantity_variance, :integer

    # 2. Crear tabla para Ajustes Manuales (Día a Día)
    create_table :stock_adjustments do |t|
      t.integer :warehouse_id
      t.integer :item_id
      t.string :adjustment_type # 'entrada' o 'salida'
      t.integer :quantity
      t.string :reason          # 'merma', 'rotura', 'vencido', 'error_ingreso', 'otro'
      t.integer :user_id

      t.timestamps
    end
  end
end
