# -*- encoding: utf-8 -*-

require "acme/smileage/commands/base"

module Acme
  class Smileage
    module Commands
      class Oricon < Thor
        option :single, :type => :boolean
        option :album, :type => :boolean
        desc "show [--album]", "Prints oricon sales data"
        def show
          show_sales_data(:oricon)
        end

        private

        def show_sales_data(sales)
          sm = Acme::Smileage.new
          filter = options[:album] ? :album? : :single?

          puts "初動売上  累積売上  初動比  最高位  登場回  発売日      タイトル"
          sm.discography(&filter).each do |album|
            print_sales_data(album, album.__send__(sales))
          end
        end

        def print_sales_data(album, sales)
          return unless sales
          puts "%s枚  %s枚  %.2f    %s位   %s回    %s  %s" % [
            format_number(sales.first_week_sales, 5),
            format_number(sales.total_sales, 5),
            sales.total_to_first_week_ratio,
            format_number(sales.peak_rank, 3),
            format_number(sales.weeks_on_chart, 2),
            album.release_date,
            album.name
          ]
        end

        def format_number(n, rank)
          ("%0#{rank}d" % n).reverse.gsub( /(\d{3})(?=\d)/, '\1,').reverse.gsub(/^(0+)/) { '*' * $1.length }
        end
      end
    end
  end
end
