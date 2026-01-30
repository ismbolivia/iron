class PurchaseOrderLine < ApplicationRecord
	belongs_to :purchase_order
	belongs_to :item 
	has_many :stocks
	has_many :purchase_order_lines_taxes
    has_many :taxes, through: :purchase_order_lines_taxes
    
    has_many :receptions
    validates :item_qty, presence: true
    validates :price_unit, presence: true
	enum state: [:borrador, :confirmado,:parcial, :recibido, :asignado]

	def subtotal
		 self.item_qty ? item_qty * price_unit : 0
	end
	def price_tax
		self.price_tax = self.subtotal ?  (self.subtotal* self.get_total_tax)/100 :0
		save
		 res = self.subtotal ?  (self.subtotal* self.get_total_tax)/100 :0
	end
	 def get_total_tax
 		purchase_order_lines_taxes = self.purchase_order_lines_taxes

		total = 0.0
		purchase_order_lines_taxes.flat_map do |d|
			total += d.tax.amount
		end
		total
	 end

	 def qty_received
	 	receptions = self.receptions
		total = 0
		receptions.flat_map do |r|
			total += r.qty_in			
		end
		self.qty_received = total
		save
		total
	 end
	 def get_total_warehouse_stock
	 		stocks = self.stocks
	 		total = 0
	 		stocks.flat_map do |e|
			total += e.qty_in			
		end
		total
	 end
	 def get_available_line_item
	 	 res = self.qty_received - self.get_total_warehouse_stock
	 end
		
end