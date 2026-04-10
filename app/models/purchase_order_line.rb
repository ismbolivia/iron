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

	def final_cost
		(self.price_unit.to_f * (1 - (self.discount.to_f / 100.0))).round(4)
	end

	def subtotal
		 (self.item_qty.to_f * self.final_cost).round(4)
	end
	def price_tax
		tax_amt = self.get_total_tax.to_f
		res = (self.subtotal.to_f * tax_amt / 100.0).round(4)
		self.update_columns(price_tax: res) if self.persisted?
		res
	end
	 def get_total_tax
 		lines_taxes = self.purchase_order_lines_taxes
		total = 0.0
		lines_taxes.flat_map do |d|
			total += d.tax.amount.to_f
		end
		total
	 end

	 def qty_received
	 	receptions = self.receptions
		total = 0
		receptions.flat_map do |r|
			total += r.qty_in.to_i			
		end
		self.update_columns(qty_received: total) if self.persisted?
		total
	 end
	 def get_total_warehouse_stock
	 		stocks = self.stocks
	 		total = 0
	 		stocks.flat_map do |e|
			total += e.qty_in.to_i			
		end
		total
	 end
	 def get_available_line_item
	 	 res = self.qty_received.to_i - self.get_total_warehouse_stock.to_i
	 	 res < 0 ? 0 : res
	 end

	 def display_qty
	 	item.format_qty(self.item_qty)
	 end

	 def display_qty_received
	 	item.format_qty(self.qty_received)
	 end
		
end