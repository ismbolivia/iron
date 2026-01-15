class Category < ApplicationRecord
	mount_uploader :pictures, PictureUploader
	has_many :items
	validates :name, presence: true
	validates_with ValidateUnaccent, model: self
end
