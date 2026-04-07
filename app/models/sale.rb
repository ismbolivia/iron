class Sale < ApplicationRecord
  PAYMENT_STATUSES = {
    pending_payment: "PENDIENTE DE PAGO",
    partially_paid: "PARCIALMENTE PAGADA",
    expired_pending_payment: "VENCIDA PENDIENTE DE PAGO",
    expired_partially_paid: "VENCIDA PARCIALMENTE PAGADA",
    paid: "PAGADA",
    annulled: "ANULADO",
    draft: "BORRADOR",
    quoted: "COTIZACION",
    to_annul: "PARA ANULAR",
    canceled: "PAGADA",
    observed: "OBSERVADA"
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
	belongs_to :branch, optional: true
	belongs_to :observer, class_name: 'User', foreign_key: 'observed_by_user_id', optional: true
	validates :number, presence: true
	validates :date, presence: true
	accepts_nested_attributes_for :sale_details, reject_if: :sale_detail_rejectable?,
									allow_destroy: true
	enum state: [:draft, :confirmed, :canceled, :annulled, :quoted, :observed]
	enum invoiced: [:por_facturar, :facturado]

	after_save :process_stock_changes, if: -> { saved_change_to_state? || confirmed? }
	after_save :update_status_priority!
	before_destroy :restore_all_stock
	after_commit :clear_dashboard_cache

	def process_stock_changes
		if confirmed?
			# Siempre recalculamos para asegurar consistencia en ediciones
			recalculate_stock_fifo
		elsif draft? || annulled? || quoted?
			# Si se anuló o volvió a borrador, restauramos stock
			restore_all_stock
		end
	end

	def recalculate_stock_fifo
		# 1. Restaurar stock actual sin borrar los detalles, solo movimientos
		self.sale_details.reload.each do |detail|
			detail.movements.each do |m|
				s = m.stock
				if s
					s.update_columns(qty_out: s.qty_out - m.qty_out, state: :disponible)
				end
				m.destroy
			end
		end
		
		# 2. Volver a descontar usando FIFO con las cantidades nuevas
		self.sale_details.reload.each do |detail|
			Sale.deduct_stock(detail.qty, detail.item_id, detail.id) if detail.qty.to_f > 0
		end
	end

	def restore_all_stock
		self.sale_details.reload.each do |detail|
			detail.movements.each do |m|
				s = m.stock
				if s
					s.update_columns(qty_out: s.qty_out - m.qty_out, state: :disponible)
				end
				m.destroy
			end
		end
	end

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
		details = self.sale_details.includes(:item)
		total = 0.0
		details.flat_map do |d|
			total += d.subtotal
		end
		total.round(2)
	end
	def sub_total_before_devolution
		details = self.sale_details.includes(:item)
		total = 0.0
		details.flat_map do |d|
			if d.todiscount
					total += d.subtotal
			end

		end
		total.round(2)
	end
	def sub_total_afther_devolution
		details = self.sale_details.includes(:item)
		total = 0.0
		details.flat_map do |d|
			if !d.todiscount
					total += d.subtotal
			end

		end
		total.round(2)
	end
	def sub_total_op
		details = self.sale_details.includes(:item)
		total = 0.0
		details.flat_map do |d|
			total += d.subtotal
		end
		(total).round(2)
	end
	def sub_total
		details = self.sale_details.includes(:item)
		total = 0.0
		details.flat_map do |d|
			if d.todiscount
				total += d.subtotal
			end

		end
		(total).round(2)
	end
	def total_pagos
		my_payments = self.payments.where.not(state: :rejected)

		total = 0.0
		my_payments.flat_map do |p|
			total += p.rode
		end
		total.round(2)
	end
	def total_des_pagos
		my_payments = self.payments.where.not(state: :rejected)
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
			res = "VALIDO 3 DIAS"
		else
			res = " "
		end
	end
	def discount_all
		discount_sal = self.discount
		discount_total = discount_sal.to_i
	end
	def duscount_mount_all
		 mount = (self.sub_total.to_f * self.discount_all.to_f / 100.0).round(2)
	end
	def duscount_mount_all_final
		 mount = (self.sub_total.to_f * self.discount_total.to_f / 100.0).round(2)
	end
	def duscount_mount_all_final_op
		 mount = (self.sub_total_op.to_f * self.discount_total.to_f / 100.0).round(2)
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
		sale_detail_item = self.sale_details.find_by(item_id: id)
		sale_detail_item
	end

	def payment_status
		# 1. Estados que anulan o borran la venta
		if draft?
		  return PAYMENT_STATUSES[:draft]
		end

		if quoted?
			return PAYMENT_STATUSES[:quoted]
		end

		if observed?
			return PAYMENT_STATUSES[:observed]
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

		  # 2. Estado de Pagada
		  # Se considera PAGADA si el saldo es menor o igual a 1.0 (incluye margen para errores históricos de redondeo).
		  # Esto protege las ventas a crédito nuevas (Saldo > 1.0) y rescata las antiguas pagadas correctamente.
		  if balance <= 1.0
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
	  
		# Valor por defecto - Basado en saldo real si es confirmado/cerrado
		if confirmed? || canceled?
		  (self.total_pagos.to_f > 0) ? PAYMENT_STATUSES[:partially_paid] : PAYMENT_STATUSES[:pending_payment]
		else
		  self.annulled? ? PAYMENT_STATUSES[:annulled] : PAYMENT_STATUSES[:draft]
		end
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
		  PAYMENT_STATUSES[:quoted]                   => 9,
		  PAYMENT_STATUSES[:canceled]                   => 5,
		  PAYMENT_STATUSES[:observed]                   => 10
		}
		
		current_status = self.payment_status
		new_priority = priority_map[current_status] || 99
		
		# Use update_column to avoid triggering callbacks and validations,
		# preventing an infinite loop if this method is called from an after_save callback.
		if self.status_priority != new_priority || self.payment_status_cache != current_status
			self.update_columns(status_priority: new_priority, payment_status_cache: current_status)
		end
	end

	def self.deduct_stock(qty, item_id, sale_detail_id)
		cantidad = qty.to_i
		
		detail = SaleDetail.find(sale_detail_id)
		sale = detail.sale
		stocks = Item.find(item_id).stocks
		
		# Filtrar por almacenes de la sucursal de la venta si existe asignada
		if sale&.branch_id.present?
			warehouse_ids = Warehouse.where(branch_id: sale.branch_id, active: true).pluck(:id)
			stocks = stocks.where(warehouse_id: warehouse_ids) if warehouse_ids.any?
		end
		
		# Usamos el saldo real (entrada - salida > 0) para determinar disponibilidad
		# PRIORIDAD 1: FIFO (Los lotes más antiguos primero)
		# PRIORIDAD 2: Presentación (Si el lote tiene varias presentaciones, prioriza la seleccionada)
		mystocks = stocks.where("qty_in - qty_out > 0").lock(true)
		mystocks = mystocks.order(created_at: :asc)
		
		if detail.presentation_id.present?
			# Dentro de los lotes habilitados por fecha, intentamos que coincida la presentación
			# Pero el orden de created_at manda para el despacho secuencial
			mystocks = mystocks.order(Arel.sql("created_at ASC, CASE WHEN presentation_id = #{detail.presentation_id.to_i} THEN 0 ELSE 1 END"))
		else
			mystocks = mystocks.order(created_at: :asc)
		end
		
		stock_current = mystocks.first

		raise "Stock insuficiente e inesperado durante la transacción" unless stock_current

		if stock_current.total > qty
		  stock_current.qty_out += qty
		  stock_current.save!
		  Movement.create!(qty_out: qty, qty_in: 0, sale_detail_id: sale_detail_id, stock_id: stock_current.id)

		elsif stock_current.total == qty
		  stock_current.qty_out += qty
		  stock_current.state = 'agotado' 
		  stock_current.save!
		  Movement.create!(qty_out: qty, qty_in: 0, sale_detail_id: sale_detail_id, stock_id: stock_current.id)

		elsif stock_current.total < qty
		  qty_current_movement = stock_current.total 
		  new_qty = qty - stock_current.total
		  
		  stock_current.qty_out += stock_current.total
		  stock_current.state = 'agotado' 
		  stock_current.save!

		  Movement.create!(qty_out: qty_current_movement, qty_in: 0, sale_detail_id: sale_detail_id, stock_id: stock_current.id)   
		  
		  # Llamada recursiva segura dentro de la transacción
		  deduct_stock(new_qty, item_id, sale_detail_id) 
		end
	end
	def clear_dashboard_cache
		# Invalida automáticamente el cache para que el Dashboard se refresque en la siguiente visita
		Rails.cache.delete("user_#{self.user_id}_total_ventas_v1")
		Rails.cache.delete("user_#{self.user_id}_total_por_cobrar_v1")
	end
	private
		def sale_detail_rejectable?(att)
			att[:item_id].blank? || att[:qty].blank? || att[:qty].to_f <= 0
		end
end
