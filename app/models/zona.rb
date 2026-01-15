class Zona < ApplicationRecord
	has_one :address
	has_many :avenidas
	belongs_to :province
	has_many :addresses
	validates :name, presence: true
end
