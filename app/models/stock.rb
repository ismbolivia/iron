class Stock < ApplicationRecord
	belongs_to :item
	belongs_to :warehouse
	belongs_to :presentation, optional: true
	belongs_to :purchase_order_line, optional: true
	belongs_to :repacking, optional: true
	has_one :stock_adjustment, foreign_key: :stock_id
	has_many :movements, dependent: :destroy
	enum state: [:agotado, :disponible]
	validate  :custom_validation_method_with_message

	def custom_validation_method_with_message	
		if qty_out == 0	
			if !qty_in.present?	
				errors.add(:_, "La cantidad debe existir")
			end
			if qty_in.to_f <= 0 
				 errors.add(:_, "La cantidad debe ser mayor a 0")
			end
			
			# No limitamos los ajustes manuales si el usuario necesita subir stock extraordinario
			# if self.purchase_order_line_id.present? && qty_in > PurchaseOrderLine.find(self.purchase_order_line_id).get_available_line_item
			# 	errors.add(:_, "Monto no debe exeder el monto disponible")
			# end 
		end	
	end

	def total
		total = self.qty_in.to_d - self.qty_out.to_d
	end

	def display_qty_in
		item.format_qty(self.qty_in)
	end

	def display_qty_out
		item.format_qty(self.qty_out)
	end

	def display_total
		item.format_qty(self.total)
	end
end


