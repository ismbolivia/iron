class Inventory < ApplicationRecord
	has_many :inventory_items, inverse_of: :inventory, dependent: :destroy
	has_many :items, through: :inventory_items

	def total_price
		items = self.inventory_items

		total = 0.0
		items.flat_map do |i|
			total += i.stock * i.price
		end
		total
	end
	def TotalAmountInventory
		inventoryItems = self.inventory_items
		total = 0.0 
		inventoryItems.flat_map do |ii|
			total += ii.price_purchase_total
		end
		total.round(2)
	end
end