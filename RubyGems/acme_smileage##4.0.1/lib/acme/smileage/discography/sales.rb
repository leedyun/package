require "date"

module Acme
  class Smileage
    class Discography
      class Sales
        attr_reader :first_week_sales, :total_sales, :peak_rank, :weeks_on_chart

        def self.records(*records)
          if records.empty?
            return self.new(0, 0, 0, 0)
          end

          first_week_sales = records[0][:sales]
          total_sales = records.inject(0){|acc,e| acc + e[:sales] }
          peak_rank = records.map{|e| e[:rank] }.min
          weeks_on_chart = records.length

          self.new(first_week_sales, total_sales, peak_rank, weeks_on_chart)
        end

        def initialize(first_week_sales, total_sales, peak_rank, weeks_on_chart)
          @first_week_sales = first_week_sales
          @total_sales = total_sales
          @peak_rank = peak_rank
          @weeks_on_chart = weeks_on_chart
        end

        def first_week_to_total_ratio
          self.total_sales.zero? ? 0 : self.first_week_sales.to_f / self.total_sales.to_f
        end

        def total_to_first_week_ratio
          self.first_week_sales.zero? ? 0 : self.total_sales.to_f / self.first_week_sales.to_f
        end

        def to_a
          [self.first_week_sales, self.total_sales, self.peak_rank, self.weeks_on_chart]
        end
      end
    end
  end
end
