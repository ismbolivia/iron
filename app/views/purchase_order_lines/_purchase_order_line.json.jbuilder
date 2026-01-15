json.extract! purchase_order_line, :id, :name, :item_qty, :date_planned, :item_id, :price_unit, :price_tax, :purchase_order, :company_id, :state, :qty_received, :purchase_order_id, :created_at, :updated_at
json.url purchase_order_line_url(purchase_order_line, format: :json)
