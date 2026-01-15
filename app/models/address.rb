class Address < ApplicationRecord
	 belongs_to :country
	 belongs_to :departamento
	 belongs_to :province
	 belongs_to :zona
	 belongs_to :avenida
	 has_one :client
	 has_one :supplier
	  def get_direccion_all
	 	 	country = self.country
	 	 	departamento = self.departamento
	 	 	province = self.province
	 	 	zona = self.zona
	 	 	avenida = self.avenida
	 	 	res =country.name+' '+departamento.code+' '+province.name+' '+avenida.name+' '+self.calles+' '+self.description
	 	 end
	def get_direccion_cli
	 	 
	 	 	departamento = self.departamento
	 	 	province = self.province
	 	 	zona = self.zona
	 	 	avenida = self.avenida
	 	 	res = departamento.code+' '+province.name+' '+avenida.name+' '+self.calles+' '+self.description
	end
end

