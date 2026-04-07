class AddEtapaToGastosImportaciones < ActiveRecord::Migration[5.2]
  def change
    add_column :gastos_importaciones, :etapa, :integer
  end
end
