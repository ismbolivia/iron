class AddImagesupplierToSuppliers < ActiveRecord::Migration[5.2]
  def change
    add_column :suppliers, :imagesupplier, :string
  end
end
