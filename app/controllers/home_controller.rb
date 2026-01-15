class HomeController < ApplicationController
	
  def index
  	@price_list = PriceList.where(default: true).first  
  	@purchase_order_lines = PurchaseOrderLine.where(state: "recivido").or(PurchaseOrderLine.where(state: "parcial"))
 	@pol_prices = PurchaseOrderLine.where(to_prices: true).limit(10).order(:id)
 	# limit(10).
  end
  
end