require "google-search"

require "gimme_vins/version"

module GimmeVins
  def self.for(query)
    results = Google::Search::Web.new({
      query: "#{query} vin"
    })

    results.map { |r| r.content.scan(/[A-Z0-9]+{17}/) }.flatten.uniq
  end
end
