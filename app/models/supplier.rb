class Supplier < ApplicationRecord
	mount_uploader :imagesupplier, ImagesupplierUploader
	has_many :purchase_orders
	belongs_to :address
	
    validates :name, presence: true
	validates :address_id, presence: true
	validates :nit, presence: true

	# has_many :items, inverse_of: :supplier, dependent: :destroy
 # 	has_many :items_suppliers, through: :items

 	  has_many :items_suppliers, inverse_of: :supplier, dependent: :destroy
  	  has_many :items, through: :items_suppliers

	  enum is_company: [:individual, :company]
	  enum state: [:draft, :confirmed]
end





