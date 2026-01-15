class ItemsSuggestionController < ApplicationController
	def index
		if params[:query].present?
			query = params[:query]
			supplier_id = params[:supp]
			condition1 = "unaccent(lower(items.description)) LIKE '%#{I18n.transliterate(query.downcase)}%'" 
			condition2 = condition1 + " OR unaccent(lower(items.code)) LIKE '%#{I18n.transliterate(query.downcase)}%'"
			condition3 = condition2 + " OR unaccent(lower(items.name)) LIKE '%#{I18n.transliterate(query.downcase)}%'"
			condition4 = condition3 + " OR unaccent(lower(brands.name)) LIKE '%#{I18n.transliterate(query.downcase)}%'"			 			

			if params[:supp].present?
				items_supplier = Supplier.find(supplier_id).items
					@items = items_supplier.joins(:brand).where(condition4)
				# @items = Item.joins(:brand).where(condition2)
			else
				@items = Item.where(active:true).joins(:brand).where(condition4)
			end			
			# Item.joins(:brand).where(condition2)
			@items.each do |item|
				item.description = item.item_description
			end
		end
		@items ||= Item.none

		render json: @items
	end
end