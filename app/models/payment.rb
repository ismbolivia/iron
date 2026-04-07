class Payment < ApplicationRecord
	has_many :box_details, dependent: :destroy
	belongs_to :sale
	belongs_to :payment_type
	belongs_to :account, optional: true
	belongs_to :box, optional: true

	enum state: [:draft, :confirmed, :rejected]
	validates :account, presence: true, unless: -> { box_id.present? }
	validates :box, presence: true, if: -> { payment_type_id == 1 }
	validates_numericality_of :rode, :greater_than => 0

	after_save :update_sale_status_priority
	after_destroy :update_sale_status_priority
	after_create :create_box_detail_if_cash, if: -> { confirmed? }
	after_update :create_box_detail_if_cash, if: -> { saved_change_to_state? && confirmed? }
	after_initialize :set_default_state, if: :new_record?
	before_save :calculate_commission, if: -> { confirmed? }

	def calculate_commission
		vendedor = self.sale&.user
		if vendedor.present?
			tasa = vendedor.commission_rate || 0.0
			self.commission_amount = (self.rode.to_f * tasa.to_f / 100.0).round(2)
		end
	end

	def set_default_state
		self.state ||= :draft
	end

	def get_discount_payment
		d = discount || 0
		res = self.sale.total_final_afther ? ((self.sale.total_final_afther)*d)/100 : 0
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
		d = discount || 0
		if d > 0
			res = "Desc. " + self.get_discount_payment.to_s	
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

	def create_box_detail_if_cash
		if payment_type_id == 1 && box_id.present?
			BoxDetail.create!(
				box_id: box_id, 
				amount: rode, 
				reason: "Cobro Recibo ##{self.get_num_payment} - Venta ##{self.sale_id}", 
				state: "input",
				payment_id: self.id
			)
		end
	end
end
