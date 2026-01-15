class ValidateSuggestedSaleController < ApplicationController
  def index
  			sale = []
		if params[:payment_sale].present?
			payment_sale = params[:payment_sale]

			sale = Sale.where(number: payment_sale, user_id: current_user.id)
		end
		if !sale.empty?
			result = [valid: true, id: sale.ids, ex: sale.first.client.name, dir: sale.first.client.address.get_direccion_all, saldo: sale.first.saldo]

		else
			result = [valid: false, id: 0]
		end
		render json: result
  end
  def saldo
  	sale_id = params[:sale_id]
  	discount = params[:disc].to_d
  	sale = Sale.find(sale_id)
  	saldo_affter_before = sale.total_final_afther
  	amount_discount = saldo_affter_before*(discount/100)
  	saldo_fine = sale.saldo-amount_discount 
  	render json: saldo_fine.round(2);
  end
end
