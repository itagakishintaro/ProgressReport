json.array!(@events) do |event|
  json.extract! event, :id, :title, :start, :end, :color, :allDay
  json.url event_url(event, format: :json)
end
