class SaleDetail < ApplicationRecord
	belongs_to :sale
	belongs_to :item
	has_many  :movements
	has_many :devolutions
	validates :item_id, presence: true
	validates :qty, presence: true
	validates :price, presence: true
	validates :discount, presence: true

	accepts_nested_attributes_for :item

	def subtotal
		self.qty ? ((self.qty - qty_devolutions) * price_sale ).round(2) : 0
	end
	def sTotal
		self.qty ? ((self.qty - qty_devolutions) * price ).round(2) : 0
	end

	def unit_price
		if persisted?
			price
		else
			item ? item.price : 0
		end
	end
	def get_discount
		if self.item.todiscount
			self.qty ? ((qty * unit_price)*getTotalDiscount)/100 : 0
		else
		res  =	0
		end
		
	end
	def price_select
		
	end
	def current_available_credit
		total = self.sale.client.line_credit_available
		current_price_item = self.subtotal
		res = total+current_price_item

	end
	def qty_devolutions
		devolutions = self.devolutions
		total = 0
			devolutions.flat_map do |d|
				total += d.qty
			end
		total
	end
	def get_qty_total
		total = self.qty - self.qty_devolutions
	end
	def getTotalDiscount
		res = 0
		res = discount

	end
	def getTotalSaleDetailsAmounto
		total = self.qty*price_sale
		dis =1 - (self.sale.discount/100)
		if self.todiscount
			total = total*dis
		end
		total
	  # code
	end
	
	after_save :update_sale_status_priority
	after_destroy :update_sale_status_priority
  
	private
  
	def update_sale_status_priority
	  self.sale.update_status_priority!
	end
end
