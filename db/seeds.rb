# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Item.destroy_all
Company.destroy_all
Country.destroy_all
Warehouse.destroy_all
Category.destroy_all
Modulo.destroy_all
Unit.destroy_all
Brand.destroy_all


Country.create([
	{   
		name: "Bolivia",
		code: "BO",
		phone_code: "+591"

	},
	{   
		name: "Brasil",
		code: "BR",
		phone_code: "+55"

	},
	{   
		name: "Alemania",
		code: "AL",
		phone_code: "+49"

	},
	{   
		name: "Japon",
		code: "JP",
		phone_code: "+81"

	},
	{     
		name: "China",
		code: "CH",
		phone_code: "+86"

	},
	{     
		name: "Argentina",
		code: "Arg",
		phone_code: "+54"

	},
	{     
		name: "Venezuela",
		code: "Vn",
		phone_code: "+58"

	},
	{     
		name: "Colombia",
		code: "Cl",
		phone_code: "+57"

	},
	{     
		name: "Mexico",
		code: "Mx",
		phone_code: "+52"

	}
])

p "Created Conutres #{Country.count} entries."

Unit.create([
	{ 	name: "Pza." },		
	{ 	name: "Bolsa." },	
	{ 	name: "Caja." },		
	{ 	name: "Groz." },	
	{ 	name: "Tambor." },	
	{ 	name: "Rollo." },	
	{ 	name: "Kg." },		
	{ 	name: "Jgo." },		
	{ 	name: "Cien" },		
	{ 	name: "Mil" },	
	{ 	name: "Caja" },		
	{ 	name: "Paquete" },	
	{ 	name: "Doc." },		
	{ 	name: "Par" },		
	{ 	name: "Tarr." },	

])

p "Created Unit #{Unit.count} entries."


Brand.create([
	{
		name: "FISCHER",
		country_id: 6
	},
	{
		name: "IVA PLAST",
		country_id: 2
	},
	{
		name: "CISER",
		country_id: 2
	},
    {
		name: "NAUVO",
		country_id: 2
	},
	{
		name: "MTV",
		country_id: 3
	},
	{
		name: "DIAMONT",
		country_id: 5
	},
	{
		name: "IPA",
		country_id: 7
	},
	{
		name: "DYNAL",
		country_id: 7
	},
	{
		name: "PRODAC",
		country_id: 5
	},
	{
		name: "ROYAL",
		country_id: 5
	},
	{
		name: "LION BALL",
		country_id: 5
	},
	{
		name: "ANGELITO",
		country_id: 3
	},

	{
		name: "DEBOR",
		country_id: 3
	},
	{
		name: "SHIQIU",
		country_id: 5
	},
	{
		name: "WHITE NITROGEN",
		country_id: 5
	},
	{
		name: "VIAPOL",
		country_id: 2
	},
	{
		name: "SKC",
		country_id: 4
	},
		{
		name: "LIZHAN",
		country_id: 5
	},
	{
		name: "DELIUS",
		country_id: 3
	},
	{
		name: "BOON",
		country_id: 3
	},
		{
		name: "ARNDT",
		country_id: 3
	},
	{
		name: "FELDER",
		country_id: 3
	},
	{
		name: "SRC",
		country_id: 5
	},
	{
		name: "STANNOL",
		country_id: 3
	},
	{
		name: "NICHOLSON",
		country_id: 9
	},
	
	{
		name: "SASSIN",
		country_id: 5
	},	
	{
		name: "KS",
		country_id: 5
	},
	{
		name: "BS",
		country_id: 5
	},
	{
		name: "BEWELL",
		country_id: 5
	},
	{
		name: "GATO",
		country_id: 8
	},
	

	{
		name: "KELLER",
		country_id: 2
	},
	
	


])

p "Created Brands #{Brand.count} entries."

Category.create([
	{ name: "Abrazaderas metalicas" },			
	{ name: "Pernos de expación" },				
	{ name: "Ramplus S" },							
	{ name: "Ramplus A" },						
	{ name: "Ramplus GDP" },					
	{ name: "Ramplus FU" },						
	{ name: "Autoperforante" },					
	{ name: "Tornillos PA" },					
	{ name: "Tornillos PB" },					
	{ name: "Dado magnetico" },						
	{ name: "Brocas NCD"},						
	{ name: "Brocas con regulador" },			
	{ name: "Armellas cerradas" },				
	{ name: "Armellas abiertas" },				
	{ name: "Alcayatas" },						
	{ name: "Aldabas" },						
	{ name: "Alquitran"},						
	{ name: "Carton" },							
	{ name: "Alambres galvanizado"},				
	{ name: "Bisagras vaiven" },				
	{ name: "Bisagras piano"},					
	{ name: "Brocas de concreto"},				
	{ name: "Brocas de concreto 200mm"},		
	{ name: "Brocas de concreto 400mm"},		
	{ name: "Brocas HSS-R"},					
	{ name: "Brocas HSS XL"},					
	{ name: "Brocas Largas HSS"},				
	{ name: "Brocas SDS"},						
	{ name: "Brocas tipo gusano"},				
	{ name: "Brocas aguja"},					
	{ name: "Brocas LEWIS"},						
	{ name: "Brocas HSS-Co"},					
	{ name: "Brocas HSS-G"},					
	{ name: "Cadenas G"},						
	{ name: "Cadenas galvanizadas"},				
	{ name: "Cable Ac. PVC"},					
	{ name: "Cable Ac. galvanizadas"},			
	{ name: "Eslabones con rosca"},				
	{ name: "Ganchos con pasador"},				
	{ name: "Ganchos con seguro"},				
	{ name: "Grampas de acero"},					
	{ name: "Guarda cabos"},					
	{ name: "Grilletes Ac."},					
	{ name: "Grilletes TN."},					
	{ name: "Mosqueton con rosca"},				
	{ name: "Mosqueton sin rosca"},				
	{ name: "Tesador p/Ac."},					
	{ name: "Tesador c/Palanca."},				
	{ name: "Carburos"},						
	{ name: "Espatula"},						
	{ name: "Cierra puertas"},					
	{ name: "Cinta asfaltico"},						
	{ name: "Dado hexagonal"},					
	{ name: "Clavo de acero"},					
	{ name: "Dado de acero UNC"},				
	{ name: "Dado de acero UNF"},				
	{ name: "Porta dado"},						
	{ name: "Escuadra"},						
	{ name: "Esquineros"},						
	{ name: "Limas"},							
	{ name: "Llaves allen"},					
	{ name: "Mallas tejida BWG"},				
	{ name: "Mallas plastica BWG"},				
	{ name: "Mallas de aluminio"},				
	{ name: "Mallas fibra de vidrio"},			
	{ name: "Mallas milimetricas MB"},			
	{ name: "Llaves mandril"},					
	{ name: "Machos UNC"},						
	{ name: "Machos UNF"},						
	{ name: "Machos"},							
	{ name: "Machos NPT"},							
	{ name: "Porta machos"},					
	{ name: "Juego de machos"},					
	{ name: "Pomadas para soldar"},				
	{ name: "Puntas PH"},							
	{ name: "Remaches POP"},					
	{ name: "Sales"},							
	{ name: "Sierra huincha"},					
	{ name: "Sierras mecanicas"},				
	{ name: "Soldaduras bronce"},				
	{ name: "Timbres"},							
	{ name: "Tirafondos"},						
	{ name: "Tornillos chipboard"},					
	{ name: "Grampas electricas KS"},			
	{ name: "Grampas electricas BS"},			
	{ name: "Bisagras pispote"},				
	{ name: "Chapitas p/muebles"},				
	{ name: "Chapitas p/vidrio"},				
	{ name: "Pispotes "},						
	{ name: "Rieles"},							
	{ name: "Rieles corredizos"},				
	{ name: "Rodapies"},						
	{ name: "Tachones"},						
	{ name: "Tapitas"},							

])

p "Created Category #{Category.count} entries."

Company.create([
	{
		name: "Mi Compañia",
		sigla: "ISM",
		nit: "6465114",
		email: "micompañia@gmail.com",
		phone: "4455442",
		company_registration: "10000",
		report_footer: "compañia",
		mycompany: true,
		country_id: Country.first.id		
	}
])

p "Created Company #{Company.count} entries."



Currency.create([
	{
		id:1,
		name:"USD",
		symbol:"$",
		rounding: 0.05,
		active:true,
		currency_unit_label: "Dolares Americanos ",
		currency_subunit_label: "Centavos"
		
	},
	{
		id:2,
		name:"BOB",
		symbol:"Bs",
		rounding: 0.05,
		active:true,
		currency_unit_label: "Bolivianos ",
		currency_subunit_label: "Centavos"
		
	}
])

p "Created Currencies #{Currency.count} entries."

SettingCurrencyCompany.create([
	{
		id:1,
		company_id: Company.first.id,
		currency_id: Currency.first.id		
	}
])

p "Created SettingCurrencyCompany #{SettingCurrencyCompany.count} entries."




Warehouse.create([
	{
		id:1,
		ref:"#A001",
		name: "Mi Almacen",
		description: "Este alamacen no se usa para realizar operaciones",
		active:true,
		company_id: Company.first.id
		
	}
])

p "Created Warehouse #{Warehouse.count} entries."

Modulo.create([
	{
		name: "Inicio",
		active: false,
		color: "btn btn-icons-navbar fcbtn  fcbtn  btn-primary btn-outline btn-1c",
		icon: "fas fa-tv",
		installed: true			
		
	},
	
	{
		name: "Productos",
		active: false,
		color: "btn btn-icons-navbar fcbtn  fcbtn  btn-primary btn-outline btn-1c",
		icon: "fas fa-box",
		installed: true			
		
	},
	{
		name: "Comercial",
		active: false,
		color: "btn btn-icons-navbar fcbtn  fcbtn  btn-primary btn-outline btn-1c",
		icon: "fas fa-handshake",
		installed: true			
		
	},
	{
		name: "Financiero",
		active: false,
		color: "btn btn-icons-navbar fcbtn  fcbtn  btn-primary btn-outline btn-1c",
		icon: "fas fa-credit-card",
		installed: true			
		
	},
	{
		name: "Contabilidad",
		active: false,
		color: "btn btn-icons-navbar fcbtn  fcbtn  btn-primary btn-outline btn-1c",
		icon: "fas fa-calculator",
		installed: true			
		
	},
	{
		name: "Ajustes",
		active: false,
		color: "btn btn-icons-navbar fcbtn  fcbtn  btn-primary btn-outline btn-1c",
		icon: "fas fa-cogs",
		installed: true			
		
	},
	
])

p "Created Modulo #{Modulo.count} entries."

Rol.create([
	{
		name: "Invitado",
		permision: 0
		
	},
	{
		name: "Cliente",
		permision: 1
		
	},
	{
		name: "Almacenero",
		permision: 2	
		
	},
	{
		name: "Vendedor",
		permision: 3
		
	},
	{
		name: "Gerente",
		permision: 4
	},
	{
		name: "Propietario",
		permision: 5
	},
	
	{
		name: "Administrador",
		permision: 6			
		
	}
		
])

p "Created Rol #{Rol.count} entries."

