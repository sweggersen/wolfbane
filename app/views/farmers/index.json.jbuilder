json.array!(@farmers) do |farmer|
  json.extract! farmer, :email, :name, :password, :phone
  json.url farmer_url(farmer, format: :json)
end
