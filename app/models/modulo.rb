class Modulo < ApplicationRecord
	has_many :user_modulos, inverse_of: :modulo, dependent: :destroy
	has_many :users, through: :user_modulos
end
