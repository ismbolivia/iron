class Box < ApplicationRecord
	enum box_type: { 
    central_matriz: 0,        # Antes 'general'
    ruta: 1,                  # ¡OBLIGATORIO 1! Para no corromper tus cajas 'route' existentes.
    central_sucursal: 3,      # Cajas centrales de cada sucursal
    sucursal_ruta: 4,         # Cajas de rutas de los vendedores de sucursal
    caja_chica: 5             # Antes 'petty_cash'
  }
	has_many :box_users, inverse_of: :box, dependent: :destroy 
	has_many :users, through: :box_users
	has_many :box_details
	belongs_to :currency 
	belongs_to :branch, optional: true

	# Jerarquía de Rendición de Cuentas
	belongs_to :parent_box, class_name: 'Box', optional: true
	has_many :dependent_boxes, class_name: 'Box', foreign_key: 'parent_box_id', dependent: :nullify

	validate :validate_hierarchy_no_ciclos

	has_many :box_purchase_order_payments, inverse_of: :box, dependent: :destroy
	has_many :purchase_orders, through: :box_purchase_order_payments

	def saldo
		res = self.totalInput - self.totalOutput		
	end
	def totalOutput
		self.box_details.where(state: "output").sum(:amount).to_f.round(2)
	end

	def totalInput
		self.box_details.where(state: "input").sum(:amount).to_f.round(2)
	end

	def name_with_currency
		operator = self.box_users.activo.first&.user&.name rescue nil
		subtext = operator.present? ? " - [#{operator}]" : ""
		"#{self.name}#{subtext} (#{self.currency.try(:symbol) || 'N/A'})"
	end

	private

	def validate_hierarchy_no_ciclos
		if parent_box_id.present? && id.present? && parent_box_id == id
			errors.add(:parent_box_id, "no puede asignarse a sí misma como dependencia")
		end
	end

end