json.array!(@medicals) do |medical|
  json.extract! medical, :datetime, :weight, :notes
  json.url medical_url(medical, format: :json)
end
