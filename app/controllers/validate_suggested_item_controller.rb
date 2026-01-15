class ValidateSuggestedItemController < ApplicationController
  def index
  		item = []
		if params[:item_description].present?
			item_description = params[:item_description]
			condition1 = "unaccent(lower(items.description)) LIKE '%#{I18n.transliterate(item_description.downcase)}%'" 
			condition2 = condition1 + " OR unaccent(lower(items.code)) LIKE '%#{I18n.transliterate(item_description.downcase)}%'"
			condition3 = condition2 + " OR unaccent(lower(items.name)) LIKE '%#{I18n.transliterate(item_description.downcase)}%'"
			condition4 = condition3 + " OR unaccent(lower(brands.name)) LIKE '%#{I18n.transliterate(item_description.downcase)}%'"
			item = Item.joins(:brand).where(condition4)
		end
		if !item.empty?


			if !item.first.stocks.empty?
				result = [valid: true, id: item.first.id, price: item.first.price_default, discount: item.first.getDiscountClientSale(params[:current_client_id]), my_prices: item.first.my_prices(params[:current_client_id]),
				 stock_current:item.first.get_total_stock, presentations: item.first.presentations, notice: 'Transacción exitosa', my_unidad: item.first.unit.name, price_sale_unit: item.first.price_sale_unit(params[:current_client_id]) ]
			else
				result = [valid: false, id: 0, notice: '¡EL produccto selecionado no existe en nuestro stocks realice una orden de compra por favor.!']
			end				
		else
			result = [valid: false, id: 0, notice: '¡No existe el Producto en nuestros almacenes.!']
		end
		render json: result
  end
   def purchase_item_suggested
  				item = []
		if params[:item_description].present?
			item_description = params[:item_description]
			condition1 = "unaccent(lower(items.description)) LIKE '%#{I18n.transliterate(item_description.downcase)}%'"
			condition2 = condition1 + " OR unaccent(lower(items.code)) LIKE '%#{I18n.transliterate(item_description.downcase)}%'"
			condition3 = condition2 + " OR unaccent(lower(items.name)) LIKE '%#{I18n.transliterate(item_description.downcase)}%'"
			condition4 = condition3 + " OR unaccent(lower(brands.name)) LIKE '%#{I18n.transliterate(item_description.downcase)}%'"
			item = Item.joins(:brand).where(condition4)

		end
      pp = 0.0
    if item.first.purchase_order_lines.count>0
      pp=item.first.purchase_order_lines.last.price_unit
    end
		if !item.empty?
			result = [valid: true, id: item.first.id, price: pp, discount: item.first.discount, item_unit: item.first.unit.name]
		else
			result = [valid: false, id: 0]
		end
		render json: result
  end
 
end
  
  

  