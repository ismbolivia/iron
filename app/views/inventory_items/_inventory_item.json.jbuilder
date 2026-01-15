json.extract! inventory_item, :id, :inventory_id, :item_id, :code_item, :name_item, :description_item, :quantity_product, :price_purchase_total, :price_sale_total, :variance, :user_id, :created_at, :updated_at
json.url inventory_item_url(inventory_item, format: :json)
