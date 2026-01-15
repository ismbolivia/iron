class ClientPriceList < ApplicationRecord
	belongs_to :client
	belongs_to :price_list
end
