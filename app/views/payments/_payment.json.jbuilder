json.extract! payment, :id, :sale_id, :payment_type_id, :account, :num_payment, :discount, :created_at, :updated_at
json.url payment_url(payment, format: :json)
