class Departamento < ApplicationRecord
	validates :name, presence: true
	has_many :provinces
	belongs_to :country
end
