class CreateSettingCurrencyCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :setting_currency_companies do |t|
      t.integer :company_id
      t.integer :currency_id

      t.timestamps
    end
  end
end
