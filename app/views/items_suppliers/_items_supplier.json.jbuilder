json.extract! items_supplier, :id, :item_id, :supplier_id, :state, :created_at, :updated_at
json.url items_supplier_url(items_supplier, format: :json)
