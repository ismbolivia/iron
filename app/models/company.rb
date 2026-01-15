class Company < ApplicationRecord
  mount_uploader :logo, LogoUploader
  belongs_to :country
  has_many :warehouses
  has_many :setting_currency_companies, inverse_of: :company, dependent: :destroy
  has_many :currencies, through: :setting_currency_companies

    validates :name, :nit, :email, :phone, :country_id, :company_registration, presence: true
    validates :nit, :company_registration,  :numericality => { :greater_than_or_equal_to => 1000, :less_than_or_equal_to => 999999999999 } 

  def get_current_currency
		currency = self.currencies.where(:active => true).first
	end
  def get_sales_year
    sales = Sale.all
  end
 
end
