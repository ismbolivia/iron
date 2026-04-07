class Devolution < ApplicationRecord
	belongs_to :sale_detail
	belongs_to :sale

	def get_price_unidad
		self.sale_detail.price_sale
	end

	def mount_devolution
		(self.qty.to_i * self.get_price_unidad.to_f).round(2)
	end

	def get_discount
		(self.qty.to_i * self.get_price_unidad.to_f * self.sale_detail.discount.to_f / 100.0).round(2)
	end

	after_save :update_sale_status_priority
	after_destroy :update_sale_status_priority
  
	private
  
	def update_sale_status_priority
	  self.sale.update_status_priority!
	end
end
