class BoxUser < ApplicationRecord
belongs_to :user
belongs_to :box	

enum acction: [:activo, :desactivo]
end
