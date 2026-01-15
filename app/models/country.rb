class Country < ApplicationRecord
	has_many :brands
	has_many :addresses
	has_many :departamentos
	validates :name, presence: true
	validates :name, uniqueness: true
end
