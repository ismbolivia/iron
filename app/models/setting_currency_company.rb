class SettingCurrencyCompany < ApplicationRecord
	belongs_to :company
	belongs_to :currency 
	validates :currency_id, uniqueness: true
end

