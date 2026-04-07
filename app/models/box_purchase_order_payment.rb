class BoxPurchaseOrderPayment < ApplicationRecord
	belongs_to :box
	belongs_to :purchase_order
	# validates_numericality_of :amount, :greater_than => 0 , presence: true

	validate  :custom_validation_method_with_message

	 def custom_validation_method_with_message	
		if !amount.present?		
			errors.add(:_, "Monto debe existir")
		end
		if !purchase_order_id.present?		
			errors.add(:_, "La orden de compra debe existir")
		end
		  if amount <= 0 
		  	errors.add(:_, "Monto debe ser mayor a 0")
		  end
		  if self.box.saldo <= amount
		  	errors.add(:_, "Su saldo es insuficiente no tiene fondos suficientes")
		  end
		  if self.box.ruta? || self.box.sucursal_ruta?
		  	errors.add(:_, "Caja de ruta no tiene permitido realizar pagos a proveedores")
		  end
	end
end


