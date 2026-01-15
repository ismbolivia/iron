class CheckPayment < ApplicationRecord
	belongs_to :check
	belongs_to :payment_type
	validate  :custom_validation_method_with_message
	enum state: [:draft, :confirmed]

	def custom_validation_method_with_message	
		if rode.present?		
			if check.present?		
				
			    if rode <= 0
			      errors.add(:_, "Monto debe ser mayor a 0")
			    end
			    if check.saldoTotalPaymentCheck <= 0
			    	errors.add(:_, "No tiene saldo en su cuenta ")	    	
			    end
			    if check.saldoTotalPaymentCheck < rode
			    	errors.add(:_, "Saldo insuficiente")	
			    end
			    if Sale.find(sale_id).total_final < rode.to_i
			    		errors.add(:_, "El monto es mayor que el saldo: " + Sale.find(sale_id).total_final.to_s)
			    end
		    end
		else
			errors.add(:_, "Monto debe existir")
		end
	end

	def getDataToAccounts
		check = self.check
		res = check.number.to_s+ '  '+check.bank.name+' '+check.titular	 
	end	
	
end



