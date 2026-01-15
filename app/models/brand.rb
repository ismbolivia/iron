class Brand < ApplicationRecord
	 belongs_to :country
	validates_with ValidateUnaccent, model: self
	validates :name, presence: true
end
