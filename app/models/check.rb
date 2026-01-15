class Check < ApplicationRecord
	belongs_to :bank
	belongs_to :currency
	has_many :check_payments, dependent: :destroy
	validates :number, presence: true, :numericality => { :greater_than_or_equal_to => 1 }
	validates :titular, presence: true
	validates :amount, presence: true, :numericality => { :greater_than_or_equal_to => 0}
	validates :date_giro, presence: true


	def full_name_combo
		bank = self.bank
		texto = self.number.to_s+"->"+bank.name+"--"+ "--"+ self.titular+"--" + "("+ self.saldoTotalPaymentCheck.to_s+")"
	end

	 def saldoTotalPaymentCheck
	 	checkPayments = self.check_payments
	  	total = 0.0
		 checkPayments.flat_map do |c|
		 	total += c.rode
		 end
		 self.amount - total 
	 end

end
