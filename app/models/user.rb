class User < ApplicationRecord
  include PermissionsConcern
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
   mount_uploader :avatar, AvatarUploader
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :sales
  has_many :clients
  belongs_to :rol
  has_many :user_modulos, inverse_of: :user, dependent: :destroy
  has_many :modulos, through: :user_modulos

  has_many :box_users, inverse_of: :user, dependent: :destroy 
  has_many :boxes, through: :box_users 
  has_many :accounts 
  
  def my_clients
    cant = self.clients.count
    cant
  end
  def my_sales
    cant = self.sales.count
    cant
  end
  def totalVentas
    total = 0.0
    sales = self.sales
    sales.flat_map do |s|
      if !s.canceled?
         total += s.total_final
      end
      
    end
    total.round(2).to_s 
  end
  def totalPagos  
    total = 0.0
    sales = self.sales
    sales.flat_map do |s|
       total += s.total_pagos
    end
    total.to_s 
  end
  def totalPorCobrar
     total = 0.0
      sales = self.sales
      sales.flat_map do |s|
       total += s.saldo
       end
      total.to_s 
  end
end

