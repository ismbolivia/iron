class InventoryItem < ApplicationRecord
	belongs_to :inventory
	belongs_to :item

	before_save :calculate_variance

	def calculate_variance
		if physical_quantity.present?
			# Diferencia = Físico - Sistema
			self.quantity_variance = physical_quantity - quantity_product.to_i
		else
			self.quantity_variance = 0
		end
	end
end
