json.extract! purchase_order, :id, :name, :date_order, :supplier_id, :currency_id, :state, :note, :created_at, :updated_at
json.url purchase_order_url(purchase_order, format: :json)
