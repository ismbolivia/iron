json.extract! account_sale, :id, :account_id, :sale_id, :amount, :created_at, :updated_at
json.url account_sale_url(account_sale, format: :json)
