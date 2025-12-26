require 'active_support/all'
require 'spider_monkey/config'
require 'spider_monkey/validator'
require 'spider_monkey/helper'

ActiveSupport.on_load(:action_view) do
  include SpiderMonkey::Helper
end

module Spidertester
end