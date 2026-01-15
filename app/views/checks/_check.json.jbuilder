json.extract! check, :id, :bank_id, :number, :date_giro, :date_payment, :titular, :amount, :created_at, :updated_at
json.url check_url(check, format: :json)
