class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :sigla
      t.string :nit
      t.string :email
      t.string :phone
      t.string :company_registration
      t.string :report_footer
      t.boolean :mycompany
      t.references :country, foreign_key: true

      t.timestamps
    end
  end
end
