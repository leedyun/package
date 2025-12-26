require 'spec_helper'

describe Cinch::Plugins::Weatherman do

  include Cinch::Test

  before(:each) do
    @bot = make_bot(Cinch::Plugins::Weatherman)
  end

  describe 'weather' do
    it 'should allow users to ask for weather by zip' do
      msg = make_message(@bot, '!weather 94062')
      expect(get_replies(msg).last.text)
       .to include('In Redwood City, CA it is')
    end

    it 'should allow users to ask for weather by city, state' do
      msg = make_message(@bot, '!weather redwood city, ca')
      expect(get_replies(msg).last.text)
       .to include('In Redwood City, CA it is')
    end

    it 'should return temps' do
      msg = make_message(@bot, '!weather redwood city, ca')
      expect(get_replies(msg).last.text)
        .to match(/\d+F/)
    end

    it 'should allow users to ask for weather by airport code' do
      msg = make_message(@bot, '!weather SFO')
      expect(get_replies(msg).last.text)
       .to include('In San Francisco International, CA it is')
    end

    it 'should return an error when location not found' do
      msg = make_message(@bot, '!weather 34')
      expect(get_replies(msg).last.text)
       .to include('Sorry, couldn\'t find 34.')
    end

    it 'should allow users to append forecasts' do
      bot = make_bot(Cinch::Plugins::Weatherman, { append_forecast: true })
      msg = make_message(bot, '!weather 94062')
      message = get_replies(msg).last.text
      expect(message).to include('In Redwood City, CA it is')
      expect(message).to include('Tommorrow;')
    end

  end

  describe 'forecast' do
    it 'should allow users to ask for forecast by zip' do
      msg = make_message(@bot, '!forecast 94062')
      expect(get_replies(msg).last.text)
       .to include('Tommorrow in Redwood City, CA;')
    end

    it 'should allow users to ask for forecast by city, state' do
      msg = make_message(@bot, '!forecast redwood city, ca')
      expect(get_replies(msg).last.text)
       .to include('Tommorrow in Redwood City, CA;')
    end

    it 'should allow users to ask for forecast by airport code' do
      msg = make_message(@bot, '!forecast SFO')
      expect(get_replies(msg).last.text)
       .to include('Tommorrow in San Francisco International, CA;')
    end

    it 'should return an error when location not found' do
      msg = make_message(@bot, '!forecast 34')
      expect(get_replies(msg).last.text)
       .to include('Sorry, couldn\'t find 34.')
    end

    it 'should return temps' do
      msg = make_message(@bot, '!weather redwood city, ca')
      expect(get_replies(msg).last.text)
       .to match(/\d+F/)
    end
  end
end
