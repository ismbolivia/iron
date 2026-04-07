json.extract! transfer, :id, :origin_branch_id, :destination_branch_id, :date, :state, :user_id, :observations, :created_at, :updated_at
json.url transfer_url(transfer, format: :json)
