class BankAccount < ApplicationRecord
	belongs_to :bank
	belongs_to :currency
	has_many :deposits
	has_many :payment_type_bank_accounts
	validates :number, presence: true
    validates :titular, presence: true
	def fullName
		full_name = self.number.to_s+ ' -> '+self.bank.name+'--'+self.titular+"("+ self.currency.symbol.to_s+". " + self.total_deposits.to_s+")"	 
	end	
	def total_deposits
    	checks = self.deposits
		total = 0.0
		self.deposits.flat_map do |c|
			total += c.rode
		end
		total - paymentoToalToBankAccounts
	end
	 def paymentoToalToBankAccounts
	 	totalPaymentsDeposits = self.payment_type_bank_accounts
	 	total = 0.0
		totalPaymentsDeposits.flat_map do |c|
			total += c.monto
		end
		total 
	 end
	 def getDataToAccounts
		res = self.number.to_s+ '  '+self.bank.name+' '+self.titular	 
	end	


end
