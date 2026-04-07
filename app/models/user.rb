class User < ApplicationRecord
  include PermissionsConcern
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
   mount_uploader :avatar, AvatarUploader
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :sales
  has_many :clients
  has_many :transfers
  belongs_to :rol
  belongs_to :branch, optional: true
  has_many :user_modulos, inverse_of: :user, dependent: :destroy
  has_many :modulos, through: :user_modulos

  has_many :box_users, inverse_of: :user, dependent: :destroy 
  has_many :boxes, through: :box_users 
  has_many :accounts 
  
  def my_clients
  clients.count
end

def my_sales
  sales.count
end

def totalVentas
  # Se suman solo ventas Confirmadas y Pagadas
  Rails.cache.fetch("user_#{self.id}_total_ventas_v2", expires_in: 10.minutes) do
    sql = <<-SQL
      SELECT COALESCE(SUM((subtotal_raw) * (1 - discount / 100.0)), 0) as total
      FROM (
        SELECT sales.id, COALESCE(sales.discount, 0) as discount, SUM(COALESCE(sale_details.qty, 0) * COALESCE(sale_details.price_sale, 0)) as subtotal_raw
        FROM sales
        LEFT JOIN sale_details ON sale_details.sale_id = sales.id
        WHERE sales.user_id = #{self.id} AND sales.state IN (1, 2)
        GROUP BY sales.id, sales.discount
      ) as sale_aggregates
    SQL
    result = ActiveRecord::Base.connection.execute(sql)
    result.first['total'].to_f.round(2).to_s
  end
end

def totalPagos  
  # Sumamos pagos que pertenecen a ventas reales (no anuladas ni borradores/cotizaciones)
  Payment.joins(:sale).where(sales: { user_id: self.id, state: [:confirmed, :canceled] }).where.not(state: :rejected).sum(:rode).to_f.round(2).to_s
end

def totalPorCobrar
  # Expresión matemática: Sum(saldo) = Sum(total_final) - Sum(total_pagos)
  venta_total = totalVentas.to_f
  pagos_total = totalPagos.to_f
  
  # Restar descuentos de pagos si existen (segun Sale#saldo)
  descuentos_pagos = totalDescuentosPagos.to_f
  
  (venta_total - pagos_total - descuentos_pagos).round(2).to_s
end

def totalDescuentosPagos
  # Suma de descuentos de pagos optimizada 100% en SQL
  sql = <<-SQL
    SELECT COALESCE(SUM((subtotal_raw) * (1 - sale_discount / 100.0) * (payment_discount / 100.0)), 0) as total
    FROM (
      SELECT sales.id, COALESCE(sales.discount, 0) as sale_discount, COALESCE(payments.discount, 0) as payment_discount, 
             SUM(COALESCE(sale_details.qty, 0) * COALESCE(sale_details.price_sale, 0)) as subtotal_raw
      FROM sales
      LEFT JOIN sale_details ON sale_details.sale_id = sales.id
      INNER JOIN payments ON payments.sale_id = sales.id
      WHERE sales.user_id = #{self.id} AND sales.state IN (1, 2) AND payments.state != 2 AND payments.discount > 0
      GROUP BY sales.id, sales.discount, payments.id, payments.discount
    ) as sale_aggregates
  SQL
  result = ActiveRecord::Base.connection.execute(sql)
  result.first['total'].to_f.round(2)
end

  def can_direct_pay?
    # Permitido ÚNICAMENTE para Administradores (rol 7)
    self.rol_id == 7
  end
end
