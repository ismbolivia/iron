json.extract! box_detail, :id, :box_id, :payment_id, :amount, :created_at, :updated_at
json.url box_detail_url(box_detail, format: :json)
