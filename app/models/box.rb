class Box < ApplicationRecord
	has_many :box_users, inverse_of: :box, dependent: :destroy 
	has_many :users, through: :box_users
	has_many :box_details
	belongs_to :currency 

	has_many :box_purchase_order_payments, inverse_of: :box, dependent: :destroy
	has_many :purchase_orders, through: :box_purchase_order_payments

	def saldo
		res = self.totalInput + self.totalOutput		
	end
	def totalOutput
		box_details = self.box_details.where(state: "output")
		total = 0.0
		box_details.flat_map do |db|
			total += db.amount
		end
		total.round(1)
	end
	def totalInput
		box_details = self.box_details.where(state: "input")
		total = 0.0
		box_details.flat_map do |db|
			total += db.amount
		end
		total.round(1)
	end

end