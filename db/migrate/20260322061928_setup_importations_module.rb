class SetupImportationsModule < ActiveRecord::Migration[5.2]
  def change
    # 1. Crear tabla Importaciones (Contenedor/Carpeta)
    create_table :importaciones do |t|
      t.string :name
      t.integer :state, default: 0 # draft: 0, transit: 1, customs: 2, arrived: 3
      t.string :container_type      # 20ft, 40HQ, etc.
      t.date :eta_date
      t.text :notes

      t.timestamps
    end

    # 2. Crear tabla Gastos Importaciones (Hoja de Costos)
    create_table :gastos_importaciones do |t|
      t.integer :importacion_id
      t.string :description
      t.decimal :amount, precision: 12, scale: 2
      t.integer :gasto_type       # flete: 0, seguro: 1, arancel: 2, puerto: 3
      t.integer :prorrateo_method # por_fob: 0, por_volumen: 1, por_peso: 2, directo: 3

      t.timestamps
    end
    add_index :gastos_importaciones, :importacion_id

    # 3. Modificaciones en tablas existentes
    add_column :purchase_orders, :importacion_id, :integer
    add_index :purchase_orders, :importacion_id

    add_column :items, :weight_kg, :decimal, precision: 10, scale: 4, default: 0.0
    add_column :items, :volume_m3, :decimal, precision: 10, scale: 6, default: 0.0
  end
end
