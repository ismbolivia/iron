class PurchaseOrder < ApplicationRecord
	belongs_to :supplier
	belongs_to :payment_term
	belongs_to :importacion, optional: true
	belongs_to :currency, optional: true
	has_many :purchase_order_lines, inverse_of: :purchase_order, dependent: :destroy
	has_many :items, through: :purchase_order_lines

	has_many :box_purchase_order_payments, inverse_of: :purchase_order, dependent: :destroy
	has_many :boxes, through: :box_purchase_order_payments

	enum state: { draft: 0, borrador: 1, confirmed: 2, paid: 3, canceled: 4, annulled: 5 }
	belongs_to :user, foreign_key: :create_uid, optional: true
	def getFullName
		supplier = self.supplier.name
		full_name = name+"---"+ created_at.strftime("%d/%m/%Y").to_s+"---"+supplier		
	end
	def getReasonTostring		
		res = "Pago al provehedor "+ self.supplier.name+ " correspondiente al orden de compra "+self.name+  " de la fecha "+self.created_at.strftime("%d/%m/%Y")
	end
	def subtotal
		purchase_order_lines = self.purchase_order_lines
		stotal = 0.0
		purchase_order_lines.flat_map do |pol|
			stotal += pol.subtotal
		end
		stotal		
	end
	def total_payment_purchase_order
		box_purchase_order_payments = self.box_purchase_order_payments
		stotal = 0.0
		box_purchase_order_payments.flat_map do |bpop|
			stotal += bpop.amount
		end
		stotal		
	end
	def total_tax
		purchase_order_lines = self.purchase_order_lines

		total_tax = 0.0
		purchase_order_lines.flat_map do |pol|
			total_tax += pol.price_tax
		end
		total_tax		
	end
	def getState
		state = false
		if saldo <= 0
		state = true	
		end
		state		
	end
	def saldo
		res = total-total_payment_purchase_order
	end
	def total
		total =subtotal+total_tax
	end
	def confirmed
		purchase_order_lines = self.purchase_order_lines
		conf = true
		purchase_order_lines.flat_map do |pol|
			if pol.state == 'borrador'
				conf = false
			end			
		end
		conf		
	end
	def getPurchaseORderNumber
		num = self.number
		res = ''
		case  num
		when  1..9
			res = 'P000'+num.to_s
		when 10..99 
			res = 'P00'+num.to_s
		when 100..999
			res = 'P0'+num.to_s	
		when 1000..9999
			res = 'P'+num.to_s	
		else	
			res = num.to_s
		end
		res
	end
	
end
