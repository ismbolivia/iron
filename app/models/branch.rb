class Branch < ApplicationRecord
  belongs_to :company
  has_many :users
  has_many :warehouses
  has_many :sales
  has_many :boxes
end
