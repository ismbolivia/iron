class GastoImportacion < ApplicationRecord
  self.table_name = 'gastos_importaciones'
  belongs_to :importacion

  # Tipos de Gasto
  enum gasto_type: { 
    flete: 0, 
    seguro: 1, 
    arancel: 2, 
    puerto: 3, 
    despachante: 4, 
    flete_local: 5, 
    manipuleo_descarga: 6, 
    alimentacion: 7 
  }
  
  # Métodos de Prorrateo
  enum prorrateo_method: { por_fob: 0, por_volumen: 1, por_peso: 2, directo: 3 }

  # Fases de Registro (Asociado a Importacion.state)
  enum etapa: { borrador: 0, transito: 1, aduana: 2, recibido: 3, completado: 4 }

  # Valida que el monto sea positivo
  validates :amount, numericality: { greater_than: 0 }
end
