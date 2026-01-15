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
  has_many :warehouses, through: :stocks

 validates :description, presence: true

 def self.to_csv(options = {})
    desired_columns = ["id", "code", "name", "description",  "brand_id", "unit_id", "category_id", "stock", "min_stock", "price", "cost", "discount",  "active",  "warehouse_id", "image", "todiscount", "sold", "bought", "priority"]
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
      res = Client.find(client_id).discount+self.discount
     end
   res


 end
 def get_total_stock
      stocks = self.stocks
      totales = 0
      stocks.flat_map do |e|
        totales += e.total
      end
        totales
 end
 def getTotalCostos
     purchaseOrderLines = self.purchase_order_lines
      totales = 0.0
      qtys = 0
      qty_current = self.getQtSalesTotal
      purchaseOrderLines.flat_map do |poo|
        if qty_current >= poo.qty_received
          totales += poo.qty_received*poo.price_unit
          qty_current -= poo.qty_received
        else
          totales += poo.price_unit*qty_current
          break
        end
        #qtys += rec.qty_in
        #if qty_current <= qtys
        #  totales += (rec.purchase_order_line.price_unit)*qty_current
        #end

     end
         totales

 end
 def getUtility
  res = totalIemSales - getTotalCostos

 end
 def totalIemSales
     saledetails = self.sale_details
       totales = 0.0
       saledetails.flat_map do |sd|
         totales += sd.getTotalSaleDetailsAmounto
       end
         totales

 end
 def get_precio_last
    pol = self.purchase_order_lines.last.price_unit
 end


 def price_default
  price_sale = 0
    prices = self.prices
     prices.each do |p|
      if p.price_list.default
        price_sale = p.price_sale
      end
     end
   price_sale.round(4)
 end
 def price_sale_unit(client_id)
      des = 100 - getDiscountClientSale(client_id)
      price = (self.price_default*des)/100

 end
 def getPriceAsignado(data)
  price_sale = 0
    prices = self.prices
     prices.each do |p|
      if p.name == data.to_s
        price_sale = p.price_sale
      end
     end
   price_sale.round(4)
 end
  def getQtSalesTotal
      saledetailsTotal = self.sale_details
      totales = 0
      saledetailsTotal.flat_map do |sd|
        totales += sd.get_qty_total
      end
        totales
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
  spreadsheet = Roo::Spreadsheet.open(file)
  header = spreadsheet.row(1)
  (2..spreadsheet.last_row).each do |i|
    row = Hash[[header, spreadsheet.row(i)].transpose]
    item = find_by_id(row["id"]) || new
    item.attributes = row.to_hash.slice(*row.to_hash.keys)
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

   # def addstock(qty_sales)
   #  stocks = self.stocks

   # end

end
