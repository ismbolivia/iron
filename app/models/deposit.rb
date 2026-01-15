class Deposit < ApplicationRecord
	belongs_to :bank_account
	belongs_to :client
	has_many :payments, inverse_of: :deposit, dependent: :destroy
	has_many :deposit_payments, through: :payments
	# belongs_to :payment
	validates :rode, presence: true
	validates :depositante, presence: true

	def number_recibo
		
	end
end