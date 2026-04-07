class Account < ApplicationRecord
	has_many :taxes
	belongs_to :currency	
	belongs_to :user
	has_many :account_sales, inverse_of: :account, dependent: :destroy
	has_many :sales, through: :account_sales
	has_many :payments
	has_many :account_expenses
	has_many :transfers_out, class_name: "AccountTransfer", foreign_key: "from_account_id"
	has_many :transfers_in, class_name: "AccountTransfer", foreign_key: "to_account_id"

	def total_a_cobrar
		sales = self.sales
		total = 0.0
		sales.flat_map do |s|
			total += s.saldo
		end
		total
	end
	def format_code
		code = self.code.to_i
		res = ''
		case  code
		when  1..9
			res = '#0000'+code.to_s
		when 10..99 
			res = '#000'+code.to_s
		when 100..999
			res = '#00'+code.to_s	
		when 1000..9999
			res = '#0'+code.to_s	
		else	
			res = '#'+code.to_s
		end
		res
	end
	def total
		@total ||= ((payments_total + transfers_in_total) - (total_exenses + transfers_out_total)).round(2)
	end

	def payments_total
		self.payments.sum(:rode).to_f.round(2)
	end

	def total_exenses
		self.account_expenses.sum(:amount).to_f.round(2)
	end

	def transfers_out_total
		self.transfers_out.sum(:amount).to_f.round(2)
	end

	def transfers_in_total
		sum = 0.0
		self.transfers_in.each do |t|
			sum += t.amount.to_f * t.exchange_rate.to_f
		end
		sum.round(2)
	end


end