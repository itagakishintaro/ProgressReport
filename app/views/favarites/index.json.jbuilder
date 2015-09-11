json.array!(@favarites) do |favarite|
  json.extract! favarite, :id, :user_id, :report_id
  json.url favarite_url(favarite, format: :json)
end
