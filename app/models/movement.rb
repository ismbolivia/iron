class Movement < ApplicationRecord
	 belongs_to :sale_detail, optional: true
	 belongs_to :stock
end
