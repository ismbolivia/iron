class PaymentTypeBankAccount < ApplicationRecord
	belongs_to :payment_type
	belongs_to :bank_account
	validate  :custom_validation_method_with_message

	enum state: [:draft, :confirmed]
	def custom_validation_method_with_message	
		if monto.present?		
			if bank_account.present?		
				
			    if monto <= 0
			      errors.add(:_, "Monto debe ser mayor a 0")
			    end
			    if bank_account.total_deposits <= 0
			    	errors.add(:_, "No tiene saldo en su cuenta ")	    	
			    end
			    if bank_account.total_deposits < monto
			    	errors.add(:_, "Saldo insuficiente")	
			    end
			    if Sale.find(sale_id).total_final < monto.to_i
			    		errors.add(:_, "El monto es mayor que el saldo: " + Sale.find(sale_id).total_final.to_s)
			    end
		    end
		else
			errors.add(:_, "Monto debe existir")
		end
	end
	def isPosibility
		saldo = self.bank_account.total_deposits
		res = false

		if saldo > 0
			res = true
		end
		res
	end
end
