class Payment < ApplicationRecord
	has_many :box_details
	belongs_to :sale
	belongs_to :payment_type
	belongs_to :account


	# has_many :checks, inverse_of: :payment, dependent: :destroy
	# has_many :check_payments, through: :checks

	# has_many :deposits, inverse_of: :payment, dependent: :destroy
	# has_many :deposit_payments, through: :deposits

	enum state: [:draft, :confirmed]
	validates :account, presence: true
	# validates :account, numericality: true
	validates_numericality_of :rode, :greater_than => 0

	after_save :update_sale_status_priority
	after_destroy :update_sale_status_priority

	def get_discount_payment
		res = self.sale.total_final_afther ? ((self.sale.total_final_afther)*discount)/100 : 0
	end
	def get_num_payment
		num = self.num_payment
		res = ''
		case  num
		when  1..9
			res = '0000'+num.to_s
		when 10..99 
			res = '000'+num.to_s
		when 100..999
			res = '00'+num.to_s	
		when 1000..9999
			res = '0'+num.to_s	
		else	
			res = num.to_s
		end
		res
	end
	
	def get_concepto
		res = ""
		saldo = self.sale.saldo
		rode =  self.rode
		if saldo >  0
			res = "P/Acta"
		else
			res = "P/Total"
		end
		res
	end
	def obs
		res = ""
		if self.discount > 0
		res = "Desc. "+self.get_discount_payment.to_s	
		end

		res
	end

	def getToStringPaymentTypes
		 return self.payment_type.nethod+" N° Cuenta: "+ BankAccount.find(self.bank_account_id).getDataToAccounts.to_s
		
	end
	def getToStringCheckPayment
		return self.payment_type.nethod+" N° Cheque: "+ CheckPayment.find(self.check_payment_id).getDataToAccounts.to_s
	end
	def getToStringPaymentCurrency
		return self.payment_type.nethod
	end

	private

	def update_sale_status_priority
	  self.sale.update_status_priority!
	end
end
