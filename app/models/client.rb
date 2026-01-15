class Client < ApplicationRecord
	 mount_uploader :photo, PhotoUploader
	 has_many :sales
	 has_many :contacts
	 has_many :deposits
	 belongs_to :address
	 # belongs_to :price_list
	 has_many :client_price_lists #, inverse_of: :client, dependent: :destroy
	 has_many :price_lists, through: :client_price_lists

	 validates :name, presence: true
	 validates :address_id, presence: true
	 validates :discount, presence: true
	 validates :credit_limit, presence: true
 def phones
	 	 	phone = self.phone
	 	 	mobil = self.mobile	 	 		 	
	 	 	res = phone+' - '+ mobil
	end
	def get_saldo_total
		sales = self.sales

		total = 0.0
		sales.flat_map do |s|
			total += s.saldo
		end
		total.round(1)
	end
	def get_sale_total
		sales = self.sales

		total = 0.0
		sales.flat_map do |s|
			total += s.total_final
		end
		total.round(1)
	end

	def get_asignado
		user = User.find(self.asig_a_user_id)
		name = user.name
	end
	# iobtenemos todos los pagos del cliente
	def payments_all
		payments = Array.new
		self.sales.each do |sale|
			sale.payments.each do |payment|
				payments.push(payment)
			end			
		end	
		payments	
	end
	def payments_active
		
	end
	# obtenemos linea de credito disponible para el credito actual asignado
	def line_credit_available
		sales = self.sales.where(credit: true)
		total = 0.0
		sales.flat_map do |s|
			total += s.saldo
		end
		 res = self.credit_limit - total
		
	end
	def getPayments
		payments = []
		sales = self.sales
		sales.flat_map do |s|
			payments += s.payments
		end
		payments
	end
	def getTotalPayments
		total = 0.0
		self.getPayments.flat_map do |p|
			total += p.rode
		end
		total.round(1)
	end
	def totalContacts
		self.contacts.count
	end
	def getTotalACobrar
		sales = self.sales

		total = 0.0
		sales.flat_map do |s|
			total += s.saldo
		end
		total.round(1)
	end
	def getTotalInvoced
		sales = self.sales.where(invoiced: "facturado")
		total = 0.0
		sales.flat_map do |s|
			total += s.total_final
		end
		total.round(1)
	end
	def getTotalNotInvoced
		sales = self.sales.where(invoiced: "por_facturar")
		total = 0.0
		sales.flat_map do |s|
			total += s.total_final
		end
		total.round(1)
	end
	
	  
end

