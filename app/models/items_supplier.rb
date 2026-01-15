class ItemsSupplier < ApplicationRecord
	belongs_to :item
	belongs_to :supplier
end
