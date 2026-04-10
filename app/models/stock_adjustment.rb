class StockAdjustment < ApplicationRecord
  # Relaciones
  belongs_to :warehouse
  belongs_to :item
  belongs_to :user, optional: true

  # Validaciones
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :adjustment_type, presence: true, inclusion: { in: %w[entrada salida] }
  validates :reason, presence: true
  validate :validate_stock_for_exit

  # Callbacks
  after_create :apply_stock_change
  before_destroy :reverse_stock_change

  private

  def validate_stock_for_exit
    if adjustment_type == 'salida'
      # Calcular factor de conversión para la validación exacta
      factor = 1.0
      if self.presentation_id.present?
        pres = Presentation.find_by(id: self.presentation_id)
        factor = pres.qty.to_d if pres
      end
      
      requested_qty_base = (self.quantity.to_d * factor).round(4)
      
      # Consultamos el stock actual del item en el almacén específico
      current_balance = 0
      if self.purchase_order_line_id.present?
        stocks = Stock.where(item_id: self.item_id, warehouse_id: self.warehouse_id, purchase_order_line_id: self.purchase_order_line_id)
        current_balance = (stocks.sum(:qty_in).to_d - stocks.sum(:qty_out).to_d).round(4)
      else
        # Fallback a stock general del almacén
        stocks = Stock.where(item_id: self.item_id, warehouse_id: self.warehouse_id)
        current_balance = (stocks.sum(:qty_in).to_d - stocks.sum(:qty_out).to_d).round(4)
      end

      if current_balance <= 0
        errors.add(:base, "No se puede realizar un ajuste de salida: El lote seleccionado no tiene stock.")
      elsif requested_qty_base > current_balance
        errors.add(:quantity, "la cantidad solicitada (#{self.quantity} uni. de presentación) excede el stock disponible en el lote (#{current_balance} uni. base).")
      end
    end
  end

  def apply_stock_change
    # Calcular factor de conversión según presentación
    factor = 1.0
    if self.presentation_id.present?
      pres = Presentation.find_by(id: self.presentation_id)
      factor = pres.qty.to_f if pres
    end

    total_qty_base = self.quantity.to_f * factor
    qty_in  = 0
    qty_out = 0

    if adjustment_type == 'entrada'
      qty_in = total_qty_base
    else
      qty_out = total_qty_base
    end

    # 1. Crear el registro en la tabla Stock
    stock = Stock.create!(
      item_id: self.item_id,
      warehouse_id: self.warehouse_id,
      qty_in: qty_in,
      qty_out: qty_out,
      purchase_order_line_id: self.purchase_order_line_id,
      presentation_id: self.presentation_id,
      state: :disponible
    )

    # 2. Guardar el ID para futura reversión
    self.update_column(:stock_id, stock.id)

    # 3. Crear Movimiento para trazabilidad con auditoría
    Movement.create!(
      qty_in: qty_in,
      qty_out: qty_out,
      stock_id: stock.id,
      user_id: self.user_id,
      description: "Ajuste de Stock: #{self.reason}"
    )
  end

  def reverse_stock_change
    # Al eliminar el ajuste, buscamos y eliminamos el stock generado
    Stock.find_by(id: self.stock_id)&.destroy
  end

  def display_qty
    item.format_qty(self.quantity)
  end
end
