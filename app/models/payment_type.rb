class PaymentType < ApplicationRecord
	  has_many :payments, inverse_of: :payment_type, dependent: :destroy
  	  has_many :sales, through: :payments
	  has_many :payment_type_bank_accounts, inverse_of: :payment_type, dependent: :destroy
	  has_many :bank_accounts, through: :payment_type_bank_accounts 
end
