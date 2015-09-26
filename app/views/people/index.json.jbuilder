json.array!(@people) do |person|
  json.extract! person, :id, :nombre, :apellido, :zone_id, :updated_at
  json.url person_url(person, format: :json)
end
