json.extract! check_payment, :id, :check_id, :payment_id, :created_at, :updated_at
json.url check_payment_url(check_payment, format: :json)
