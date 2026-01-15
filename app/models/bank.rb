class Bank < ApplicationRecord
	has_many :checks
	has_many :bank_accounts
	validates :name, presence: true
    validates :description, presence: true


    def saldo
    	0.0
    end
end
