class PurchaseOrderLinesTax < ApplicationRecord
	  belongs_to :purchase_order_line
	  belongs_to :tax

end
