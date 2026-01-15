json.extract! box_purchase_order_payment, :id, :box_id, :purchase_order_id, :amount, :created_at, :updated_at
json.url box_purchase_order_payment_url(box_purchase_order_payment, format: :json)
