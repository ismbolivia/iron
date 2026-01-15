json.extract! account_expense, :id, :account_id, :amount, :description, :created_at, :updated_at
json.url account_expense_url(account_expense, format: :json)
