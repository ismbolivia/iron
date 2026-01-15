class CreateCountries < ActiveRecord::Migration[5.2]
  def change
    create_table :countries do |t|
      t.string :name
      t.string :code
      t.string :phone_code
      t.string :initials

      t.timestamps
    end
  end
end
