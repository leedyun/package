class CountMessage
  include Emque::Producing::Message

  topic "metrics"
  message_type "metrics.count"
  raise_on_failure false

  values do
    attribute :event_name, String, :required => true
    attribute :count, Integer, :required => true
  end
end
