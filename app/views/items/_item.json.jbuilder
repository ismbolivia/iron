json.extract! item, :id, :code, :name, :description, :brand_id, :unit_id, :category_id, :stock, :min_stock, :price, :cost, :active, :created_at, :updated_at
json.url item_url(item, format: :json)
