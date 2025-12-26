# -*- encoding: utf-8 -*-

require "acme/smileage/commands/oricon"

module Acme
  class Smileage
    module Commands
      class SoundScan < Oricon
        option :single, :type => :boolean
        option :album, :type => :boolean
        desc "show [--album]", "Prints soundscan sales data"
        def show
          show_sales_data(:soundscan)
        end
      end
    end
  end
end
