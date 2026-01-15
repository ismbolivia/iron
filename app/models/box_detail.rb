class BoxDetail < ApplicationRecord
	belongs_to :box
	# belongs_to :payment
	enum state: [:input, :output]
	 validate  :custom_validation_method_with_message



	 def custom_validation_method_with_message	
		if amount.present?		
			if reason.present?		
				
			    if amount <= 0 
			    	if self.input?
			    		 errors.add(:_, "Monto debe ser mayor a 0")
			    	end
			     
			    end
			    if self.box.saldo <= amount and self.output?
			    	errors.add(:_, "Su saldo es insuficiente, su saldo actual es: "+ self.box.saldo.to_s )	    	
			    end
			   
			else
			    errors.add(:_, "El motivo debe existir")
		    end
		else
			errors.add(:_, "Monto debe existir")
		end
	end
	 
end
