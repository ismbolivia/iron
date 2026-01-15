class Stock < ApplicationRecord
	belongs_to :item
	belongs_to :warehouse
	has_many :movements
	enum state: [:agotado, :disponible]
	validate  :custom_validation_method_with_message

	def custom_validation_method_with_message	
		if qty_out == 0	
		if self.movements.count <= 0	
		
			if !qty_in.present?	
				errors.add(:_, "La cantidad debe existir")
			end
			if qty_in <= 0 
				 errors.add(:_, "La cantidad debe ser mayor a 0")
			end
			if qty_in > PurchaseOrderLine.find(self.purchase_order_line_id).get_available_line_item
				errors.add(:_, "Monto no debe exeder el monto disponible")
			end 
		end	
		end

	end

	def total
		total = self.qty_in - self.qty_out 
	end
end


