class Province < ApplicationRecord
	validates :name, presence: true
	has_many :zonas
	has_many :addresses
	belongs_to :departamento
end
