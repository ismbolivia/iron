json.extract! payment_type, :id, :nethod, :description, :created_at, :updated_at
json.url payment_type_url(payment_type, format: :json)
