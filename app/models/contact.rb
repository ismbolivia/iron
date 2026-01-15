class Contact < ApplicationRecord
  mount_uploader :profile, ProfileUploader
  belongs_to :client
  validates :name, presence: true
  validates :mobile, presence: true
end
