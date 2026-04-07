json.extract! item, :id, :code, :name, :description, :brand_id, :unit_id, :category_id, :min_stock, :price, :cost, :active, :created_at, :updated_at
json.stock item.get_stock_by_branch(current_user&.branch_id)
json.active_lot_stock item.active_total_stock
json.available_lots item.available_lots_data
json.url item_url(item, format: :json)
