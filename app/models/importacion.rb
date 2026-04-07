class Importacion < ApplicationRecord
  self.table_name = 'importaciones'
  has_many :purchase_orders
  has_many :gastos_importaciones, dependent: :destroy, class_name: 'GastoImportacion'

  enum state: { borrador: 0, transito: 1, aduana: 2, recibido: 3, completado: 4 }

  # Calcula el valor FOB sumando todas las líneas de las OC asociadas
  def total_fob
    purchase_orders.flat_map(&:purchase_order_lines).sum { |l| l.item_qty.to_f * l.price_unit.to_f }
  end

  # Suma total de volumen en m3 de todos los productos
  def total_volume_m3
    purchase_orders.flat_map(&:purchase_order_lines).sum { |l| l.item_qty.to_f * (l.item&.volume_m3 || 0).to_f }
  end

  # Suma total de peso en Kg de todos los productos
  def total_weight_kg
    purchase_orders.flat_map(&:purchase_order_lines).sum { |l| l.item_qty.to_f * (l.item&.weight_kg || 0).to_f }
  end
end
