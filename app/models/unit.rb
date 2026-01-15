class Unit < ApplicationRecord
	validates :name, presence: true
	validates_with ValidateUnaccent, model: self
	has_many :presentations, inverse_of: :unit, dependent: :destroy 
    has_many :items, through: :presentations
end
