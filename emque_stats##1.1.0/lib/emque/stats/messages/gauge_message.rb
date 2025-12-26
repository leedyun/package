class GaugeMessage
  include Emque::Producing::Message

  topic "metrics"
  message_type "metrics.gauge"
  raise_on_failure false

  values do
    attribute :event_name, String, :required => true
    attribute :value, Integer, :required => true
  end
end
