class Warehouse < ApplicationRecord
	
	belongs_to :company
	belongs_to :branch, optional: true

	has_many :stocks, inverse_of: :warehouse, dependent: :destroy
    has_many :items, through: :stocks

	validates :ref, presence: true
	validates :name, presence: true
	validates :company_id, presence: true

	def total_price
		# items_warehouse = self.items
		# total = 0.0
		# items_warehouse.flat_map do |i|
		# 	# total += i.stock * i.price
		# end
		# total
	end
	def total_quantity
		# items_warehouse = self.items
		# q = 0
		# items_warehouse.flat_map do |i|
		# 	 #q += i.stock 
		# end
		# q
	end
end
