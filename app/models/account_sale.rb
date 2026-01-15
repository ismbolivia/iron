class AccountSale < ApplicationRecord
	belongs_to :sale
	belongs_to :account	
end

