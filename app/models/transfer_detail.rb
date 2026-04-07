class TransferDetail < ApplicationRecord
  belongs_to :transfer
  belongs_to :item
  belongs_to :purchase_order_line, optional: true
  belongs_to :presentation, optional: true
end
