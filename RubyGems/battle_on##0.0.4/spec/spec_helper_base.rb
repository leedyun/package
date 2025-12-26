require 'rubygems'
require 'rspec'
require 'webmock/rspec'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))

require 'lib/battle_on'
require 'lib/battle_on/register_game'
require 'lib/battle_on/send_attack'
