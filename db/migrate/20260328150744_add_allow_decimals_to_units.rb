class AddAllowDecimalsToUnits < ActiveRecord::Migration[5.2]
  def change
    add_column :units, :allow_decimals, :boolean, default: false
  end
end
