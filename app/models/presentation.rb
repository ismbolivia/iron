class Presentation < ApplicationRecord
    mount_uploader :image_presentation, ImagePresentationUploader
	belongs_to :unit
	belongs_to :item
	validates :name, presence: true  
	validates_numericality_of :qty, :greater_than => 0 , presence: true
	validates :unit_id, presence: true
	validates :item_id, presence: true
	def price
		current_price = self.item.price_default
		 res = self.qty*current_price 
	end
	def item_unit
		current_unit = 'pz'
	end

end
