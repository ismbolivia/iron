class PriceList < ApplicationRecord
	
	has_many :prices, inverse_of: :price_list, dependent: :destroy
	has_many :items, through: :prices

	has_many :client_price_lists #, inverse_of: :price_list, dependent: :destroy
	has_many :clients, through: :client_price_lists

	# has_many :price_lists
	enum state: [:activo, :desactivo]
	enum list_type: { sistema: 0, cliente: 1, publico: 2 }

	scope :operativas, -> { where(list_type: :sistema) }
	scope :catalogos, -> { where(list_type: [:cliente, :publico]) }


	validate :only_sistema_can_be_default

	def only_sistema_can_be_default
		if default && !sistema?
			errors.add(:default, "Solo las listas de tipo Sistema pueden ser marcadas como predeterminadas.")
		end
	end

	def myprice
		res = 0.0
		prices = self.prices
		prices.each do |p| 
			if p.name.equal? self.name
				res = p.price_sale
			end
		end
		res
	end

	def orderCategoryItemsPriceList
		lists = Array.new
		categories = Array.new	

		Category.all.order(:name).each do |category|
			items_prices = Array.new


			category.items.order(:priority).each do |item|
				self.items.where(active: true).order(:priority).each do |i|
					if i.id == item.id
						items_prices.push(i) 
					end
				end
			end
			# if condition
				
			# end
			if items_prices.count > 0
				categories.push(category, items_prices.uniq)
			end
			

		end		
		lists.push(self, categories)
		lists
		
	end
end
