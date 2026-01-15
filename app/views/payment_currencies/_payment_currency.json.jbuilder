json.extract! payment_currency, :id, :currency_id, :payment_type_id, :sale_id, :created_at, :updated_at
json.url payment_currency_url(payment_currency, format: :json)
