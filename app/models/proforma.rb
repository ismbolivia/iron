class Proforma < ApplicationRecord
	belongs_to :sale

	after_save :update_sale_status_priority
	after_destroy :update_sale_status_priority

	def number_recibo
		num = self.sale.number_sale
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

	private

	def update_sale_status_priority
		self.sale.update_status_priority! if self.sale
	end
end
