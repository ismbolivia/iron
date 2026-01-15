json.extract! supplier, :id, :name, :display_name, :is_company, :address_id, :nit, :job_id, :phone, :mobile, :email, :web_syte, :description, :company_id, :created_at, :updated_at
json.url supplier_url(supplier, format: :json)
