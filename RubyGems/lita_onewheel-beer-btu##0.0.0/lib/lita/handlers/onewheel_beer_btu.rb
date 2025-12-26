require 'rest-client'
require 'lita-onewheel-beer-base'
require 'open-uri'
require 'pdf-reader'

module Lita
  module Handlers
    class OnewheelBeerBtu < OnewheelBeerBase
      route /^btu$/i,
            :taps_list,
            command: true,
            help: {'btu' => 'Display the current taps.'}

      route /^btu ([\w ]+)$/i,
            :taps_deets,
            command: true,
            help: {'btu 4' => 'Display the tap 4 deets, including prices.'}

      route /^btu ([<>=\w.\s]+)%$/i,
            :taps_by_abv,
            command: true,
            help: {'btu >4%' => 'Display beers over 4% ABV.'}

      route /^btu ([<>=\$\w.\s]+)$/i,
            :taps_by_price,
            command: true,
            help: {'btu <$5' => 'Display beers under $5.'}

      route /^btu (roulette|random)$/i,
            :taps_by_random,
            command: true,
            help: {'btu roulette' => 'Can\'t decide?  Let me do it for you!'}

      route /^btuabvlow$/i,
            :taps_low_abv,
            command: true,
            help: {'btuabvlow' => 'Show me the lowest abv keg.'}

      route /^btuabvhigh$/i,
            :taps_high_abv,
            command: true,
            help: {'btuabvhigh' => 'Show me the highest abv keg.'}

      def taps_list(response)
        beers = self.get_source
        reply = 'BTU taps: '
        beers.each do |tap, datum|
          reply += "#{tap}) "
          reply += datum[:name] + ' '
          reply += '- ' + datum[:abv].to_s + '% '
          reply += ' '
          # reply += datum[:ibu].to_s + ' IBU '
        end
        reply = reply.strip.sub /,\s*$/, ''

        Lita.logger.info "Replying with #{reply}"
        response.reply reply
      end

      def send_response(tap, datum, response)
        reply = "BTU's tap #{tap}) "
        reply += "#{datum[:name]} - "
        reply += datum[:abv].to_s + '% ABV '
        reply += datum[:ibu].to_s + ' IBU '
        reply += "- #{datum[:desc]}"

        Lita.logger.info "send_response: Replying with #{reply}"

        response.reply reply
      end

      def get_source
        # Lita.logger.debug 'get_source started'
        # unless (response = redis.get('page_response'))
        #   Lita.logger.info 'No cached result found, fetching.'
        #   response = RestClient.get('http://www.btupdx.com/ftp/TapList/BTUbeerlist.pdf')
        #   redis.setex('page_response', 18000, response)
        # end
        parse_response pull_pdf
      end

      def pull_pdf
        reader = PDF::Reader.new(open 'http://www.btupdx.com/ftp/TapList/BTUbeerlist.pdf')
        reader.pages[0].text.split /\n/
      end

      # This is the worker bee- decoding the pdf into our "standard" document.
      def parse_response(response)
        gimme_what_you_got = {}
        tap = 1
        beer_name = nil
        beer_abv = nil
        beer_ibu = nil
        beer_desc = ''

        response.each_with_index do |line, index|
          line.strip!
          if index >= 2
            if line.empty?
              unless beer_name.nil?
                gimme_what_you_got[tap] = {
                    brewery: 'BTU',
                    name: beer_name.to_s,
                    desc: beer_desc.to_s.strip,
                    abv: beer_abv.to_f,
                    ibu: beer_ibu,
                    search: "#{beer_name} #{beer_desc}"
                }
                tap += 1
                beer_name = nil
                beer_desc = ''
                beer_abv = nil
                beer_ibu = nil
              end
              next
            end

            if beer_name.nil?
              beer_name = line
              next
            end

            if (matchdata = line.match(/(.+)\sIBUS\s([0-9.]+)\%\s*ABV/))
              beer_ibu = matchdata[1]
              beer_abv = matchdata[2]
              next
            end

            beer_desc += line + ' '
          end
        end

        gimme_what_you_got
      end

      Lita.register_handler(self)
    end
  end
end
