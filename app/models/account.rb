class Account < ApplicationRecord
	has_many :taxes
	belongs_to :currency	
	has_many :account_sales, inverse_of: :account, dependent: :destroy
	has_many :sales, through: :account_sales
	has_many :payments
	has_many :account_expenses
	belongs_to :user

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
		res = payments_total - total_exenses
	end
	def payments_total
		payments = self.payments
		total = 0.0
		payments.flat_map do |p|
			total += p.rode
		end
		total 
	end
	def total_exenses
		account_expenses = self.account_expenses
		total = 0.0
		account_expenses.flat_map do |ex|
			total += ex.amount
		end
		total
	end


end