class Repacking < ApplicationRecord
  belongs_to :item
  belongs_to :warehouse
  belongs_to :user
  belongs_to :origin_stock, class_name: 'Stock', foreign_key: 'origin_stock_id'
  has_many :result_stocks, class_name: 'Stock', dependent: :destroy

  # Lógica para DESHACER un re-empaque
  def undo!
    ActiveRecord::Base.transaction do
      # 1. Verificar si el stock generado ya fue vendido o movido
      if result_stocks.any? { |s| (s.qty_out || 0) > 0 }
        raise "No se puede anular: Parte de los productos generados ya han sido vendidos o movidos."
      end

      # 2. Sumar el total generado para regresarlo al origen
      total_to_return = result_stocks.sum(:qty_in)

      # 3. Restaurar Stock de Origen
      origin_stock.update!(
        qty_out: origin_stock.qty_out - total_to_return,
        state: :disponible
      )

      # 4. Registrar Movimiento de Reversa en Kardex
      Movement.create!(
        stock_id: origin_stock.id,
        qty_in: total_to_return,
        qty_out: 0,
        user_id: self.user_id,
        description: "ANULACIÓN DE RE-EMPAQUE (ID: ##{self.id}): Reincorporación de piezas al lote original"
      )

      # 5. Eliminar el stock generado (esto disparará la eliminación de sus movimientos asociados)
      result_stocks.destroy_all
      
      # 6. Eliminar el registro del re-empaque
      self.destroy!
    end
  end
end
