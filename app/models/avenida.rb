class Avenida < ApplicationRecord
	has_many :addresses
	validates :name, presence: true
end
