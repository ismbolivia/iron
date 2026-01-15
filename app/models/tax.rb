class Tax < ApplicationRecord
	belongs_to :account
	has_many :purchase_order_line_taxes
	has_many :purchase_order_lines, through: :purchase_order_line_taxes
end
