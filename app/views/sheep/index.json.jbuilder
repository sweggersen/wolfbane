json.array!(@sheep) do |sheep|
  json.extract! sheep, :serial
  json.url sheep_url(sheep, format: :json)
end
