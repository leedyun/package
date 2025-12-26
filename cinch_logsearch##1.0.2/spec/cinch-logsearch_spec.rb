# -*- coding: utf-8 -*-
require 'spec_helper'

LOG = File.join('/tmp', 'cinch-testing.log')

describe Cinch::Plugins::LogSearch do
  include Cinch::Test

  before(:all) do
    @bot = make_bot(Cinch::Plugins::LogSearch, { logs_directory: LOG })
    build_logs
  end

  it 'should not find anything if no logs are present' do
    msg = get_replies(make_message(@bot, '!search foo'), :private).first
    expect(msg.text).to eq('No matches found!')
  end

  it 'should not return any response when users search in channel' do
    expect(get_replies(make_message(@bot, '!search foo', { channel: '#foo' })))
      .to be_empty
  end

  it 'should let users search log files' do
    msg = get_replies(make_message(@bot, '!search movie'), :private).first
    expect(msg.text)
      .to eq('Found 1 matches before giving up, here\'s the most recent 5')
  end

  it 'should allow users to do complex searches' do
    msg = get_replies(make_message(@bot, '!search \sw.+\s'), :private).first
    expect(msg.text)
      .to eq('Found 3 matches before giving up, here\'s the most recent 5')
  end
end

def build_logs
  log = <<"  EOF"
  [2012-07-24 23:09:15] <Carnivor> Oh. Good. You timed out.
  [2012-07-24 23:09:20] <feen> no
  [2012-07-24 23:09:22] <feen> i got back home
  [2012-07-24 23:09:31] <Carnivor> Oh. So you got that.
  [2012-07-24 23:09:37] <Carnivor> Yay not having to resend.
  [2012-07-24 23:10:05] <silveridea> oh god, i cant know this
  [2012-07-24 23:10:12] <feen> sorry
  [2012-07-24 23:10:12] <feen> ill stop
  [2012-07-24 23:10:16] <silveridea> heh
  [2012-07-24 23:10:20] <silveridea> i just wanted to quote mal
  [2012-07-24 23:10:24] <feen> hahahahaha
  [2012-07-24 23:10:30] <feen> i need to watch a good movie
  [2012-07-24 23:10:35] <feen> OH SHIT I STILL HAVENT WATCHED TINKER TAILOR
  [2012-07-24 23:10:37] <silveridea> heat
  [2012-07-24 23:10:44] <silveridea> actually tinker tailor is pretty good
  [2012-07-24 23:10:49] <silveridea> be prepared to pay attention
  [2012-07-24 23:10:49] <feen> i've seen heat like
  [2012-07-24 23:10:51] <feen> ten thousand times
  [2012-07-24 23:11:27] <silveridea> well im going to attempt sleep
  EOF
  File.open(LOG, 'w') do |file|
    file.write(log)
  end
end
