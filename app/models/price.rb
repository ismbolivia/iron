class Price < ApplicationRecord
	  belongs_to :item
	  belongs_to :price_list
	  validates :price_purchase, presence: true
	  validates :utility, presence: true
	  validates :price_sale, presence: true
	  enum active: [:activo, :obsoleta]

	  before_validation :copy_from_default, if: -> { price_list && !price_list.sistema? }
	  after_save :sync_shadow_prices, if: -> { price_list && price_list.default? }

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

	  private

	  # 📑 Si es una lista de Clientes/Público, hereda siempre los valores de la lista Default
	  def copy_from_default
	    default_list = PriceList.find_by(default: true)
	    return unless default_list
	    
	    default_price = Price.find_by(item_id: self.item_id, price_list_id: default_list.id)
	    if default_price
	      self.price_purchase = default_price.price_purchase
	      self.utility        = default_price.utility
	      self.price_sale     = default_price.price_sale
	    end
	  end

	  # 🔄 Si cambia el precio en la lista Default, lo propagamos a todos los catálogos vinculados
	  def sync_shadow_prices
	    PriceList.catalogos.each do |list|
	      shadow_p = Price.find_by(item_id: self.item_id, price_list_id: list.id)
	      if shadow_p
	        shadow_p.update_columns(
	          price_purchase: self.price_purchase,
	          utility: self.utility,
	          price_sale: self.price_sale
	        )
	      end
	    end
	  end
end

