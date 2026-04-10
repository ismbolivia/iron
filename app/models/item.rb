require 'csv'
class Item < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :brand
  belongs_to :unit
  belongs_to :category
  # belongs_to :warehouse
  has_many :sale_details, inverse_of: :item, dependent: :destroy
  has_many :sales, through: :sale_details

  has_many :purchase_order_lines, inverse_of: :item, dependent: :destroy
  has_many :purchase_orders, through: :purchase_order_lines

  has_many :inventory_items, inverse_of: :item, dependent: :destroy
  has_many :inventory, through: :inventory_items
  # has_many :stocks

  has_many :presentations, inverse_of: :item, dependent: :destroy
  has_many :units, through: :presentations

  has_many :prices, inverse_of: :item, dependent: :destroy
  has_many :price_lists, through: :prices

  has_many :items_suppliers, inverse_of: :item, dependent: :destroy
  has_many :suppliers, through: :items_suppliers

  has_many :stocks, inverse_of: :item, dependent: :destroy
  has_many :stock_adjustments, dependent: :destroy
  has_many :warehouses, through: :stocks

 validates :description, presence: true

 def self.to_csv(options = {})
    desired_columns = ["id", "code", "name", "brand_id", "unit_id", "category_id", "stock", "min_stock", "price", "cost", "discount",  "active",  "warehouse_id", "image", "todiscount", "sold", "bought", "priority"]
    CSV.generate(options) do |csv|
      csv << desired_columns
      all.each do |product|
        csv << product.attributes.values_at(*desired_columns)
      end
    end
  end

 def item_description
   self.name + ' '+self.description + ( (self.brand != nil) ? ' ' + self.brand.name : '' )
 end

 def brand_name
  if self.brand
     self.brand.name
  else
   ''
  end
 end
 def getDiscountClientSale(client_id)
  res = 0
     if self.todiscount
      client = Client.find_by(id: client_id)
      res = (client&.discount.to_f) + self.discount.to_f
     end
   res
 end
  def get_total_stock
       stocks = self.stocks
       totales = 0.0
       stocks.each do |e|
         totales += (e.qty_in.to_f - e.qty_out.to_f)
       end
       totales.round(3)
  end
  def get_stock_by_branch(branch_id)
      return get_total_stock if branch_id.blank?
      
      warehouse_ids = Warehouse.where(branch_id: branch_id, active: true).pluck(:id)
      return 0 if warehouse_ids.empty?
      
      stocks_sub = self.stocks.where(warehouse_id: warehouse_ids)
      (stocks_sub.sum(:qty_in).to_f - stocks_sub.sum(:qty_out).to_f).round(3)
  end
  def getTotalCostos
      purchaseOrderLines = self.purchase_order_lines.joins(:purchase_order).order('purchase_orders.created_at ASC')
       totales = 0.0
       qty_current = self.getQtSalesTotal.to_i
       purchaseOrderLines.each do |poo|
         qty_rec = poo.qty_received.to_i
         if qty_current >= qty_rec
           totales += qty_rec * poo.price_unit.to_f
           qty_current -= qty_rec
         else
           totales += poo.price_unit.to_f * qty_current
           qty_current = 0
           break
         end
      end
          totales
  end
 def getUtility
  res = totalIemSales.to_f - getTotalCostos.to_f
 end
 def totalIemSales
     # Considerar ventas confirmadas y canceladas (excluye cotizaciones, borradores y anulados)
     saledetails = self.sale_details.joins(:sale).where(sales: { state: [:confirmed, :canceled] })
       totales = 0.0
       saledetails.flat_map do |sd|
         totales += sd.getTotalSaleDetailsAmounto
       end
         totales

 end
 def get_precio_last
    self.purchase_order_lines.last&.price_unit.to_f
 end


 def price_default
  price_sale = 0.0
    prices = self.prices
     prices.each do |p|
      if p.price_list.default
        price_sale = p.price_sale.to_f
      end
     end
   price_sale.round(4)
 end
 def price_sale_unit(client_id)
      des = 100 - getDiscountClientSale(client_id)
      price = (self.price_default*des)/100

 end
 def getPriceAsignado(data)
  price_sale = 0.0
    prices = self.prices
     prices.each do |p|
      if p.name == data.to_s
        price_sale = p.price_sale.to_f
      end
     end
   price_sale.round(4)
 end
  def getQtSalesTotal
      # Considerar ventas confirmadas y canceladas (excluye cotizaciones, borradores y anulados)
      saledetailsTotal = self.sale_details.joins(:sale).where(sales: { state: [:confirmed, :canceled] })
      totales = 0.0
      saledetailsTotal.each do |sd|
        totales += sd.get_qty_total.to_f
      end
      totales.round(3)
 end
def my_prices(client_id)
  prices = []
  client_price_sales = Client.find(client_id).price_lists

  client_price_sales.each do |c|
    self.prices.where(active: 'activo').each do |p|
      if p.price_list.id == c.id
        prices.push(p)
      end
    end
  end
   @prices= prices.to_json
end
def self.import(file)
  spreadsheet = open_spreadsheet(file)
  header = spreadsheet.row(1)
  (2..spreadsheet.last_row).each do |i|
    row = Hash[[header, spreadsheet.row(i)].transpose]
    # Buscamos por ID o por código para evitar duplicados
    item = find_by_id(row["id"]) || find_by_code(row["code"]) || new
    # Filtramos para asignar solo atributos que existen en el modelo
    item.attributes = row.to_hash.select { |k, v| column_names.include?(k) }
    item.save!
  end
end

def self.open_spreadsheet(file)
  case File.extname(file.original_filename)
  when ".csv" then Roo::CSV.new(file.path, nil, :ignore)
  when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
  when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
  else raise "Unknown file type: #{file.original_filename}"
  end
end

  def get_monthly_utility_stats
    # 1. Obtener detalles de ventas confirmadas y canceladas
    details = self.sale_details.joins(:sale).where(sales: { state: [:confirmed, :canceled] }).order('sales.created_at ASC')
    
    # 2. Obtener líneas de órdenes de compra recibidas (fuente de costos)
    purchases = self.purchase_order_lines.joins(:purchase_order).order('purchase_orders.created_at ASC').to_a
    
    # 3. Preparar pool de costos FIFO
    purchase_pool = purchases.map { |p| { qty: p.qty_received.to_i, price: p.price_unit.to_f } }
    purchase_pointer = 0
    
    stats = {}
    
    details.each do |sd|
      # Usar el año y mes como llave
      month_key = sd.sale.created_at.strftime("%Y-%m")
      stats[month_key] ||= { qty: 0, revenue: 0.0, cost: 0.0 }
      
      qty_sold = sd.get_qty_total.to_i
      revenue = sd.getTotalSaleDetailsAmounto.to_f
      
      stats[month_key][:qty] += qty_sold
      stats[month_key][:revenue] += revenue
      
      # Asignación de Costos FIFO
      remaining_units = qty_sold
      allocated_cost = 0.0
      
      while remaining_units > 0 && purchase_pointer < purchase_pool.size
        batch = purchase_pool[purchase_pointer]
        
        if batch[:qty] >= remaining_units
          allocated_cost += remaining_units * batch[:price]
          batch[:qty] -= remaining_units
          remaining_units = 0
        else
          allocated_cost += batch[:qty] * batch[:price]
          remaining_units -= batch[:qty]
          batch[:qty] = 0
          purchase_pointer += 1
        end
      end
      
      stats[month_key][:cost] += allocated_cost
    end
    
    # Ordenar por fecha cronológica (mes)
    stats.sort.map do |month, data|
      {
        month_label: month,
        qty: data[:qty],
        revenue: data[:revenue],
        cost: data[:cost],
        utility: data[:revenue] - data[:cost]
      }
    end
  end

  # 🔍 Encuentra los Lotes (Stock) disponibles ordenados por FIFO
  def available_stocks_fifo
    self.stocks.where("qty_in > qty_out").order(created_at: :asc)
  end

  # 📦 Estructura completa de lotes y sus presentaciones para el Frontend
  def available_lots_data
    available_stocks_fifo.includes(:stock_adjustment, :repacking).map do |s|
      po_line = s.purchase_order_line
      lote_display = s.lote.presence || (po_line ? "OC-#{po_line.purchase_order_id}" : "LOTE-#{s.id}")
      
      # Determinar origen para el Frontend (POS, etc)
      origin_type = if s.repacking_id.present?
                 "repacking"
               elsif s.stock_adjustment.present?
                 "adjustment"
               else
                 "purchase"
               end

      {
        stock_id: s.id,
        lote: lote_display,
        qty_available: (s.qty_in.to_f - s.qty_out.to_f).round(2),
        presentation: s.presentation ? { id: s.presentation.id, name: s.presentation.name, factor: s.presentation.qty.to_f } : nil,
        created_at: s.created_at,
        origin_type: origin_type,
        adjustment_reason: s.stock_adjustment&.reason
      }
    end
  end

  def has_adjustment
    self.stock_adjustments.exists?
  end

  def has_repacking
    # Detectar si alguna vez tuvo re-empaque
    self.stocks.where.not(repacking_id: nil).exists?
  end

  # 📦 Obtiene todas las presentaciones del item para darselas al vendedor
  def active_stock_presentations
    self.presentations.order(qty: :desc)
  end

  # 🔢 Calcula el stock total disponible únicamente en el lote activo actual (el más antiguo)
  def active_total_stock
    available_stocks_fifo.first&.total.to_f
  end

end
