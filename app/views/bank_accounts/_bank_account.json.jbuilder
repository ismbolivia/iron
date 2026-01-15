json.extract! bank_account, :id, :bank_id, :number, :titular, :created_at, :updated_at
json.url bank_account_url(bank_account, format: :json)
