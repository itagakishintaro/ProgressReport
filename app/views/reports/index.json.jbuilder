json.array!(@reports) do |report|
  json.extract! report, :id, :title, :tag, :content, :user_id, :created_at, :updated_at
  json.url report_url(report, format: :json)
end
