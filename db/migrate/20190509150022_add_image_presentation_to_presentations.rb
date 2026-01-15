class AddImagePresentationToPresentations < ActiveRecord::Migration[5.2]
  def change
    add_column :presentations, :image_presentation, :string
  end
end
