class Sale < ApplicationRecord
  PAYMENT_STATUSES = {
    pending_payment: "PENDIENTE DE PAGO",
    partially_paid: "PARCIALMENTE PAGADA",
    expired_pending_payment: "VENCIDA PENDIENTE DE PAGO",
    expired_partially_paid: "VENCIDA PARCIALMENTE PAGADA",
    paid: "PAGADA",
    annulled: "ANULADO",
    draft: "BORRADOR",
    to_annul: "PARA ANULAR",
    canceled: "CANCELADO"
  }.freeze

	has_many :sale_details, inverse_of: :sale, dependent: :destroy
	has_many :items, through: :sale_details

	has_many :payments, inverse_of: :sale, dependent: :destroy
	has_many :payment_type, through: :payments
	has_many :account_sales, inverse_of: :sale, dependent: :destroy
	has_many :accounts, through: :account_sales
	has_many :proformas
	has_many :devolutions
	belongs_to :user
	belongs_to :client
	validates :number, presence: true
	validates :date, presence: true
	accepts_nested_attributes_for :sale_details, reject_if: :sale_detail_rejectable?,
									allow_destroy: true
	enum state: [:draft, :confirmed, :canceled, :annulled]
	enum invoiced: [:por_facturar, :facturado]

	after_save :update_status_priority!


	def total
		des = self.duscount_mount_all
		total = (sub_total-des).round(2)
	end
def total_final_op
		if self.discount_total==nil
		   	des = self.duscount_mount_all
			total = (sub_total_op-des).round(2)
		else
			if self.penalty
				total = sub_total_op
			else
				des = self.duscount_mount_all_final_op
				total = (sub_total_op-des).round(2)
			end

		end
		total.round(2)
		# self.total = total
		# save
		total
end
	def total_final
		# if self.discount_total==nil
		#    	des = self.duscount_mount_all
		# 	total = (sub_total-des).round(2)
		# else
		# 	if self.penalty
		# 		total = sub_total
		# 	else
		# 		des = self.duscount_mount_all_final
		# 		total = (sub_total-des).round(2)
		# 	end

		# end
		# total.round(2)
		# self.total = total
		# save
		# total
		total = 0.0
		t1 =total_final_afther
		t2 = sub_total_afther_devolution
		total = t1+t2
		total.round(2)
		# self.total = total
		# save
		total
	end


	def total_final_afther
		if self.discount_total==nil
		   	des = self.duscount_mount_all
			total = (sub_total-des).round(2)
		else
			if self.penalty
				total = sub_total
			else
				des = self.duscount_mount_all_final
				total = (sub_total-des).round(2)
			end

		end
		total.round(2)
		total
	end

	def sub_total_before_devolution_op
		details = self.sale_details
		total = 0.0
		details.flat_map do |d|
			total += d.subtotal
		end
		total.round(2)
	end
	def sub_total_before_devolution
		details = self.sale_details
		total = 0.0
		details.flat_map do |d|
			if d.todiscount
					total += d.subtotal
			end

		end
		total.round(2)
	end
	def sub_total_afther_devolution
		details = self.sale_details
		total = 0.0
		details.flat_map do |d|
			if !d.todiscount
					total += d.subtotal
			end

		end
		total.round(2)
	end
	def sub_total_op
		details = self.sale_details
		total = 0.0
		details.flat_map do |d|
			total += d.subtotal
		end
		(total).round(2)
	end
	def sub_total
		details = self.sale_details
		total = 0.0
		details.flat_map do |d|
			if d.todiscount
				total += d.subtotal
			end

		end
		(total).round(2)
	end
	def total_pagos
		my_payments = self.payments

		total = 0.0
		my_payments.flat_map do |p|
			total += p.rode
		end
		total.round(2)
	end
	def total_des_pagos
		my_payments = self.payments
		total = 0.0
		my_payments.flat_map do |p|
			total += p.get_discount_payment
		end
		total.round(2)
	end
	def total_devolutions_mount
		devolutions = self.devolutions
		total = 0.0
		devolutions.flat_map do |d|
			 total += d.mount_devolution
		end
		total.round(2)
	end
	def saldo
		saldo = total_final - total_pagos - total_des_pagos
	end
	def iscredit
		if self.credit
			res = "VALIDO 30 DIAS"
		else
			res = " "
		end
	end
	def discount_all
		discount_sal = self.discount
		discount_total = discount_sal.to_i
	end
	def duscount_mount_all
		 mount = (self.sub_total ? ((sub_total)*self.discount_all)/100 : 0).round(2)
	end
	def duscount_mount_all_final
		 mount = (self.sub_total ? ((sub_total)*self.discount_total)/100 : 0).round(2)
	end
	def duscount_mount_all_final_op
		 mount = (self.sub_total_op ? ((sub_total_op)*self.discount_total)/100 : 0).round(2)
	end
	# verifica que si s epuede efectivisar la venta  mediante la disponivilidad de credito actual del cliente  en caso de que la venta sea a credito
	def destroy_sale_details_all
		self.sale_details.each do |sale_details|
        movements = sale_details.movements
        movements.each do |movement|
        stock = Stock.find(movement.stock_id)
        stock.qty_out -= movement.qty_out
        stock.state = 'disponible'
        stock.save
        movement.destroy
        end
        sale_details.destroy
      end
	end

	def is_can_sale
		# limint_credit = self.client && self.sale_details.count > 0
		can_sale = true
		if self.client.line_credit_available > 0 && self.sale_details.count > 0
			can_sale = true
		end
		can_sale
	end

	def get_user

		user = self.user
	end

	def getSaleDetail(id)
		sale_detail_item = self.sale_details.where(item_id: id).first
		qty = sale_detail_item.qty

	end

	def payment_status
		# 1. Estados que anulan o borran la venta
		if draft? || (confirmed? && proformas.empty?)
		  return PAYMENT_STATUSES[:draft]
		end
	  
		if annulled?
			return PAYMENT_STATUSES[:annulled]
		end

		# Si la venta está confirmada o canceled?a, procedemos a evaluar los estados de pago
		if confirmed? || canceled?
		  balance = self.saldo.to_f.round(2)
		  total_paid = self.total_pagos.to_f.round(2)
		  is_expired = credit_expiration.present? && Date.today > credit_expiration
	  
		  # Nuevo: Si la venta tiene total 0 y el saldo es 0, se sugiere anularla.
		  if self.total_final.to_f.round(2) == 0 && balance == 0
			return PAYMENT_STATUSES[:to_annul]
		  end

		  # 2. Estado de Pagada (siempre tiene la mayor prioridad si el saldo es 0 o menos)
		  if balance <= 0
			return PAYMENT_STATUSES[:paid]
		  end
	  
		  # 3. Evaluación de estados con saldo pendiente
		  if is_expired
			# Vencida
			if total_paid > 0
			  return PAYMENT_STATUSES[:expired_partially_paid]
			else
			  return PAYMENT_STATUSES[:expired_pending_payment]
			end
		  else
			# No Vencida
			if total_paid > 0
			  return PAYMENT_STATUSES[:partially_paid]
			else
			  return PAYMENT_STATUSES[:pending_payment]
			end
		  end
		end
	  
		# Valor por defecto en caso de no entrar en las condiciones anteriores (esto no debería ocurrir si todos los casos están cubiertos)
		self.state.humanize
	  end
	  

	def update_status_priority!
		priority_map = {
		  PAYMENT_STATUSES[:expired_pending_payment]   => 1,
		  PAYMENT_STATUSES[:expired_partially_paid] => 2,
		  PAYMENT_STATUSES[:pending_payment]           => 3,
		  PAYMENT_STATUSES[:partially_paid]         => 4,
		  PAYMENT_STATUSES[:paid]                      => 5,
		  PAYMENT_STATUSES[:annulled]                     => 6,
		  PAYMENT_STATUSES[:to_annul]                 => 7,
		  PAYMENT_STATUSES[:draft]                    => 8,
		  PAYMENT_STATUSES[:canceled]                   => 9
		}
		
		current_status = self.payment_status
		new_priority = priority_map[current_status] || 99
		
		# Use update_column to avoid triggering callbacks and validations,
		# preventing an infinite loop if this method is called from an after_save callback.
		if self.status_priority != new_priority || self.payment_status_cache != current_status
			self.update_columns(status_priority: new_priority, payment_status_cache: current_status)
		end
	end

	private
		def sale_detail_rejectable?(att)
			att[:item_id].blank? || att[:qty].blank? || att[:price].blank? || att[:qty].to_f <= 0 || att[:price].to_f <= 0
		end
end
