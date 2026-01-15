class AddPhotoToClients < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :photo, :string
  end
end
