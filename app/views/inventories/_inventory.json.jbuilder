json.extract! inventory, :id, :ref, :name_company, :name_warehouse, :ref_warehouse, :warehouse_id, :quantity, :sales_value, :created_at, :updated_at
json.url inventory_url(inventory, format: :json)
