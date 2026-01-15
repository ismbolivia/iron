json.extract! stock, :id, :qty_in, :qty_out, :total, :item_id, :created_at, :updated_at
json.url stock_url(stock, format: :json)
