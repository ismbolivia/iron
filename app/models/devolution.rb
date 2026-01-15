class Devolution < ApplicationRecord
	belongs_to :sale_detail
	belongs_to :sale

	def get_price_unidad
		self.sale_detail.price_sale
	end

	def mount_devolution
			self.qty ? self.qty * self.get_price_unidad : 0
	end
	def get_discount
		self.qty ? ((qty * self.get_price_unidad)*self.sale_detail.discount)/100 : 0
	end

	after_save :update_sale_status_priority
	after_destroy :update_sale_status_priority
  
	private
  
	def update_sale_status_priority
	  self.sale.update_status_priority!
	end
end
