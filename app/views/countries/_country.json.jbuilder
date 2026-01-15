json.extract! country, :id, :name, :code, :phone_code, :initials, :created_at, :updated_at
json.url country_url(country, format: :json)
