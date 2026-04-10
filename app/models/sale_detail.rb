class SaleDetail < ApplicationRecord
	belongs_to :sale
	belongs_to :item
	has_many  :movements
	has_many :devolutions
	validates :item_id, presence: true
	validates :qty, presence: true
	validates :price, presence: true
	validates :discount, presence: true

  before_save :validate_discount_rules

  attr_accessor :skip_stock_recalculation

  private

  def validate_discount_rules
    if self.item && !self.item.todiscount
      self.todiscount = false
      self.discount = 0.0
      self.price_sale = self.price
    elsif self.item && self.item.todiscount
      self.todiscount = true
    end
  end

  public

	accepts_nested_attributes_for :item

	def subtotal
		self.qty ? ((self.qty.to_d - qty_devolutions.to_d) * price_sale.to_d ).round(4) : 0
	end
	def sTotal
		self.qty ? ((self.qty.to_d - qty_devolutions.to_d) * price.to_d ).round(4) : 0
	end

	def unit_price
		if persisted?
			price
		else
			item ? item.price : 0
		end
	end
	def get_discount
		if self.item.todiscount
			self.qty ? ((qty * unit_price)*getTotalDiscount)/100 : 0
		else
		res  =	0
		end
		
	end
	def price_select
		
	end
	def current_available_credit
		total = self.sale.client.line_credit_available
		current_price_item = self.subtotal
		res = total+current_price_item

	end
	def qty_devolutions
		devolutions = self.devolutions
		total = 0.0
			devolutions.flat_map do |d|
				total += d.qty.to_f
			end
		total
	end
	def get_qty_total
		total = self.qty.to_f - self.qty_devolutions.to_f
	end
	def getTotalDiscount
		res = 0
		res = discount

	end
	def getTotalSaleDetailsAmounto
		total = self.qty.to_f * price_sale.to_f
		dis = 1 - (self.sale.discount.to_f / 100)
		if self.todiscount
			total = total * dis
		end
		total
	end

	def display_qty
		item.format_qty(self.qty)
	end

	def dispatch_instructions
		# Agrupamos movimientos por stock (lote y presentación) para un cálculo preciso
		valid_movs = self.movements.select { |m| m.qty_out.to_f > 0 && m.stock }
		grouped = valid_movs.group_by { |m| [m.stock.purchase_order_line_id || "SISTEMA-#{m.stock.lote}", m.stock.presentation_id] }
		
		results = []
		grouped.each do |key, movs|
			total_out = movs.sum(&:qty_out)
			stock = movs.first.stock
			pres = stock.presentation
			unit_name = self.item.unit.name.upcase rescue 'PZS'

			repacked_label = (stock.respond_to?(:repacking_id) && stock.repacking_id.present?) ? " (RE-EMPACADO)" : ""

			if pres && pres.qty.to_f > 0
				packs = (total_out / pres.qty.to_f).floor
				remainder = total_out % pres.qty.to_f
				
				if remainder > 0 && packs > 0
					results << "#{packs} #{pres.name.upcase} + #{item.format_qty(remainder)} #{unit_name}#{repacked_label}"
				elsif packs > 0
					results << "#{packs} #{pres.name.upcase}#{repacked_label}"
				else
					results << "#{item.format_qty(total_out)} #{unit_name}#{repacked_label}"
				end
			else
				results << "#{item.format_qty(total_out)} #{unit_name}#{repacked_label}"
			end
		end

		results.present? ? results.join(" Y ") : format_qty_with_presentations(self.qty, self.item)
	end

	private

	def format_qty_with_presentations(total_qty, item, exclude_id: nil)
		qty_val = total_qty.to_f
		unit_name = item&.unit&.name&.upcase || 'PZS'
		return "#{item.format_qty(qty_val)} #{unit_name}" if qty_val <= 0 || item.nil?
		
		# Buscar presentaciones del item de mayor a menor (ej. Caja -> Paquete)
		available_pres = item.presentations.where("qty > 0").order(qty: :desc)
		available_pres = available_pres.where.not(id: exclude_id) if exclude_id
		
		return "#{qty_val} #{unit_name}" if available_pres.empty?

		parts = []
		remaining = qty_val

		available_pres.each do |pres|
			pres_qty = pres.qty.to_f
			next if pres_qty == 0
			
			num = (remaining / pres_qty).floor
			if num > 0
				parts << "#{num} #{pres.name.upcase}"
				remaining %= pres_qty
			end
		end

		parts << "#{item.format_qty(remaining)} #{unit_name}" if remaining > 0
		parts.join(" + ")
	end
	
	after_save :trigger_stock_recalculation, if: -> { sale.confirmed? && !skip_stock_recalculation }
	after_destroy :trigger_stock_recalculation, if: -> { sale.confirmed? && !skip_stock_recalculation }
	after_save :update_sale_status_priority, unless: -> { skip_stock_recalculation }
	after_destroy :update_sale_status_priority, unless: -> { skip_stock_recalculation }

	private
	
	def trigger_stock_recalculation
		sale.recalculate_stock_fifo
	end
  
	def update_sale_status_priority
	  self.sale.update_status_priority!
	end
end
