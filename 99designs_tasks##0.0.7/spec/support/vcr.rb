require "vcr"
require "webmock"

VCR.configure do |c|
  # The directory where your cassettes will be saved
  c.cassette_library_dir = 'spec/cassettes'

  # Your HTTP request service. You can also use fakeweb, webmock, and more
  c.hook_into :webmock
end
