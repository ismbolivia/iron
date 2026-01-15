class Currency < ApplicationRecord
	has_many :currency_rates
	has_many :accounts
	has_many :boxes
	has_many :setting_currency_companies, inverse_of: :currency, dependent: :destroy
    has_many :companies, through: :setting_currency_companies

	validates :name, presence: true
	validates :symbol, presence: true
	validates :currency_unit_label, presence: true 
	validates :currency_subunit_label, presence: true



	def get_full_name
		get_full_name = self.currency_unit_label+'('+ self.symbol+')'
	end
	def disability
       self.currency_rates.each do |c_r|
       	c_r.update(:state => 'false')
       end
      
	end
	def get_current_currency_rate
		currency_rate = self.currency_rates.where(:state => true).first
	end
	def getChangePrices
		self.currency_rates
		
	end

def unidades(num)

    res = ''
	case num
	when 1		
		res = 'UNO'
	when 2
		res = 'DOS'
	when 3
		res = 'TRES'
	when 4
		res = 'CUATRO'
	when 5
		res = 'CINCO'
	when 6
		res = 'SEIS'
	when 7
		res = 'SIETE'
	when 8
		res = 'OCHO'
	when 9	
	res = 'NUEVE'	

	end
	res
end
def decenas(num)
	 decena = (num / 10).floor
	 unidad = num - (decena * 10)
	 res = ''
	 case decena
		 when 1
		 	case unidad
		 	when 0 
		 		res = 'DIEZ'
		 	when 1 
		 		res = 'ONCE'
		 	when 2 
		 		res = 'DOCE' 
		 	when 3 
		 		res = 'TRECE'
		 	when 4 
		 		res = 'CATORCE'
		 	when 5 
		 		res = 'QUINCE' 		
		 	else
		 		res = 'DIECI' + unidades(unidad)
		 	end
		 	
		 when 2
		 	case unidad
		 	when 0
		 		res = 'VEINTE'
		 	else
		 		res = 'VEINTI' + unidades(unidad)
		 	end
		when 3
		 	res = decenasY('TREINTA', unidad)
		when 4
		 	res =  decenasY('CUARENTA', unidad)
		when 5
			res = decenasY('CINCUENTA', unidad)
		when 6
			res = decenasY('SESENTA', unidad)
		when 7
			res = decenasY('SETENTA', unidad)
		when 8
			res = decenasY('OCHENTA', unidad)
		when 9
			res = decenasY('NOVENTA', unidad)
		 else
		 	res = unidades(unidad)
	 end
	 res
	
end
	def decenasY(strSin, numUnidades)
		res = ''
		if numUnidades > 0
			res = strSin + ' Y ' + unidades(numUnidades)
		else
			res = strSin
		end
		res
	end

	def centenas(num)
		cents = (num / 100).floor
		decs = num - (cents * 100)
		res = ''
		case cents
		when 1
			if decs > 0
				res =  'CIENTO ' + decenas(decs)
			else
				res = 'CIEN'
			end
		when 2
			res = 'DOSCIENTOS ' + decenas(decs)
		when 3
			res = 'TRESCIENTOS ' + decenas(decs)
		when 4
			res = 'CUATROCIENTOS ' + decenas(decs)
		when 5
			res = 'QUINIENTOS ' + decenas(decs)
		when 6
			res = 'SEISCIENTOS ' + decenas(decs)
		when 7
			res = 'SETECIENTOS ' + decenas(decs)
		when 8
			res = 'OCHOCIENTOS ' + decenas(decs)
		when 9			
			res = 'NOVECIENTOS ' + decenas(decs)
		else	
			res = decenas(decs)
		end
		res
	end
	def seccion(num, divisor, strSingular, strPlural)
		cientos = (num / divisor).floor 
		resto = num - (cientos*divisor)
		letras = ''
		if cientos > 0
			if cientos > 1
				 letras = centenas(cientos)+ ' '+ strPlural
			else
				letras = strSingular

			end
			
		end
		if resto > 0
			letras += ' '
			
		end
		letras
	end

	def miles(num)
		res = ''
		divisor = 1000
		cientos =  (num / divisor).floor 
		resto = num - (cientos*divisor)
		 strMiles = seccion(num, divisor, 'MIL', 'MIL')
         strCentenas = centenas(resto)
         if strMiles == ''
         	 res = strCentenas
         	else
         	res =	strMiles + ' ' + strCentenas
         end
		res 
	end
	def millones(num)
		res = ''
		divisor = 1000000
		cientos = (num / divisor).floor	
		resto = num - (cientos * divisor)
		strMillones = seccion(num, divisor, 'UN MILLON ', 'MILLONES ')	
		strMiles = miles(resto)
		if strMillones == ''
			res = strMiles
		else
			res = strMillones + ' ' + strMiles
		end
		res 

	end
	def montoLiteral(num)
		res = ''
		centavos = ((((num * 100).round) - ((num).floor * 100)))
		if centavos < 10
			centavos = '0' + centavos.to_s 
		end
		enteros = num.floor
		case enteros
		when 1..9
			res = unidades(enteros)
		when 10..99
			res = decenas(enteros)
		when 100..999
			res = centenas(enteros)
		when 1000..9999999 
		 	res = miles(enteros)
		 when 1000000..999999999
		 	res = millones(enteros)
		 		
		else 				
			return "Monto no soportado "
		end
		res = res + ' ' + centavos.to_s + '/100' + ' '+self.currency_unit_label  
		
	end
end
