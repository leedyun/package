class TrackEventMessage
  include Emque::Producing::Message

  topic "track"
  message_type "track.event"
  raise_on_failure false

  values do
    attribute :event_name, String, :required => true
    attribute :properties, Hash
  end
end
