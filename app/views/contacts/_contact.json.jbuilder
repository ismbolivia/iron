json.extract! contact, :id, :name, :title, :job, :email, :mobile, :notes, :client_id, :created_at, :updated_at
json.url contact_url(contact, format: :json)
