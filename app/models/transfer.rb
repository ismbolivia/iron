class Transfer < ApplicationRecord
  belongs_to :origin_branch, class_name: 'Branch'
  belongs_to :destination_branch, class_name: 'Branch'
  belongs_to :origin_warehouse, class_name: 'Warehouse', optional: true
  belongs_to :destination_warehouse, class_name: 'Warehouse', optional: true
  belongs_to :user
  
  has_many :transfer_details, dependent: :destroy
  accepts_nested_attributes_for :transfer_details, allow_destroy: true, reject_if: :all_blank

  enum state: { in_transit: 0, received: 1, cancelled: 2 }

  validates :date, :origin_branch, :destination_branch, presence: true
  validate :branches_must_be_different

  def branches_must_be_different
    if origin_branch_id == destination_branch_id
      errors.add(:destination_branch, "no puede ser igual a la sucursal de origen")
    end
  end

  def send_transit!
    transaction do
      deduct_origin_stock!
      self.in_transit! # cambia de enum
    end
  end

  def receive!
    transaction do
      add_destination_stock!
      self.received! # cambia de enum
    end
  end

  private

  def deduct_origin_stock!
    # Usar almacén seleccionado o el primero por defecto
    warehouse = origin_warehouse || origin_branch.warehouses.first
    raise "La sucursal de origen no tiene almacén activo" unless warehouse

    transfer_details.each do |detail|
      # 📏 Calculamos la cantidad real en base a la presentación
      factor = detail.presentation&.qty || 1
      qty_to_deduct = detail.quantity.to_f * factor
      next if qty_to_deduct <= 0
      
      # 📦 Filtramos por el lote específico si se ha seleccionado uno
      stocks_query = Item.find(detail.item_id).stocks.where(warehouse_id: warehouse.id).where("qty_in - qty_out > 0")
      stocks_query = stocks_query.where(purchase_order_line_id: detail.purchase_order_line_id) if detail.purchase_order_line_id.present?
      
      stocks = stocks_query.order(created_at: :asc).lock(true)
      
      stocks.each do |stock_current|
        break if qty_to_deduct <= 0
        
        available = stock_current.total
        if available >= qty_to_deduct
          stock_current.update!(qty_out: stock_current.qty_out + qty_to_deduct)
          qty_to_deduct = 0
        else
          stock_current.update!(qty_out: stock_current.qty_out + available, state: 'agotado')
          qty_to_deduct -= available
        end
      end
      
      raise "Stock insuficiente en almacén de origen para el producto #{detail.item.name}" if qty_to_deduct > 0
    end
  end

  def add_destination_stock!
    warehouse = destination_warehouse || destination_branch.warehouses.first
    raise "La sucursal de destino no tiene almacén activo" unless warehouse

    transfer_details.each do |detail|
      qty_to_add = detail.quantity.to_f
      next if qty_to_add <= 0

      # 📦 Mantenemos la trazabilidad del lote y la presentación original
      Stock.create!(
        qty_in: qty_to_add,
        qty_out: 0,
        item_id: detail.item_id,
        warehouse_id: warehouse.id,
        purchase_order_line_id: detail.purchase_order_line_id, # MANDATORIO PARA FIFO
        presentation_id: detail.presentation_id,
        state: 'disponible'
      )
    end
  end
end
