class Price < ApplicationRecord
	  belongs_to :item
	  belongs_to :price_list
	  validates :price_purchase, presence: true
	  validates :utility, presence: true
	  validates :price_sale, presence: true
	  enum active: [:activo, :obsoleta]

	  def name
	  	name = self.price_list.name
	  end

	  def price_last
	  	prices = self.item.prices.last
	  	if prices.nil?
	  		p = 0
	  	else
	  	 	p = self.item.prices.last.price_purchase
	  	end
	  	    p
	  end
	 
	  
end

