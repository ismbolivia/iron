class Presentation < ApplicationRecord
    mount_uploader :image_presentation, ImagePresentationUploader
 	belongs_to :unit
 	belongs_to :item
 	has_many :stocks
    
    # Jerarquía de Presentaciones (Ej: Caja -> Paquete -> Pieza)
    belongs_to :parent, class_name: "Presentation", foreign_key: "parent_id", optional: true
    has_many :children, class_name: "Presentation", foreign_key: "parent_id", dependent: :nullify

 	validates :name, presence: true  
	validates_numericality_of :qty, :greater_than => 0 , presence: true
	validates :unit_id, presence: true
	validates :item_id, presence: true
	def price
		current_price = self.item.price_default.to_f
		res = (self.qty.to_f * current_price).round(4)
	end
	def hierarchy_name
		unit_name = self.item&.unit&.name || "und."
		res = "#{name} (Total: #{qty} #{unit_name})"
		if parent_id.present?
			res += " | Embalaje: #{qty_in_parent} p/ #{parent.name}"
		end
		res
	end

	# 📦 Calcula el stock total disponible para esta presentación específica sumando todos los almacenes
	def get_total_stock
		self.stocks.sum { |s| s.qty_in.to_f - s.qty_out.to_f }.to_i
	end

end
