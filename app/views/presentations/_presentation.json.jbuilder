json.extract! presentation, :id, :name, :qty, :unit_id, :parent_id, :qty_in_parent, :created_at, :updated_at
json.url presentation_url(presentation, format: :json)
json.children presentation.children do |child|
  json.extract! child, :id, :name, :qty, :qty_in_parent
end
