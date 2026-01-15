class SalesSuggestionController < ApplicationController

		def index
		if params[:query].present?
			query = params[:query]
			
			@sales = Sale.where(number: query)
		end
		@sales ||= Sale.none

		render json: @sales
	end
end