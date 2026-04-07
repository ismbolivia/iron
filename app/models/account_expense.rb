class AccountExpense < ApplicationRecord
	belongs_to :account
	validates :amount, presence: true
	validates :amount, numericality: {  greater_than: 0 }
	validates :description, presence: true
  # Clasificación de Gastos
  enum expense_type: { fijo: 0, variable: 1, financiero: 2, ventas: 3 }
  enum expense_category: { 
    sueldos: 0, 
    alquileres: 1, 
    servicios_basicos: 2, 
    combustible: 3, 
    alimentacion: 4, 
    mantenimiento: 5, 
    impuestos: 6, 
    marketing: 7, 
    administrativo: 8 
  }
end
