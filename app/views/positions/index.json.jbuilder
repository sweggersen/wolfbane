json.array!(@positions) do |position|
  json.extract! position, :datetime, :latitude, :longitude, :attacked
  json.url position_url(position, format: :json)
end
