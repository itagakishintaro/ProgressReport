json.array!(@progresses) do |progress|
  json.extract! progress, :id, :report_id, :point
  json.url progress_url(progress, format: :json)
end
