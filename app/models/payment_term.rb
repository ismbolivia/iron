class PaymentTerm < ApplicationRecord

	has_one :purchase_order
end
