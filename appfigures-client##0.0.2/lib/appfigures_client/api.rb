module AppfiguresClient
  class Api


    URL = 'https://api.appfigures.com/v2/'


    def initialize(options)
      @request ||= Net::Request.new(options)

      data = @request.make

      if data[:status].to_i == 200
        self
      else
        raise data[:message]
      end

      @routes = YAML::load(File.open("#{AppfiguresClient.root}/config/routes.yml")).with_indifferent_access

    end

    def data
      @data ||= AppfiguresClient::Endpoints::Data.new(self, @routes[:data])
    end

    def products
      @products ||= AppfiguresClient::Endpoints::Products.new(self, @routes[:products])
    end

    def sales
      @sales ||= AppfiguresClient::Endpoints::Sales.new(self, @routes[:report][:sales])
    end

    def ads
      @ads ||= AppfiguresClient::Endpoints::Ads.new(self, @routes[:report][:ads])
    end

    def ranks
      @ranks ||= AppfiguresClient::Endpoints::Ranks.new(self, @routes[:ranks])
    end

    def reviews
      @ranks ||= AppfiguresClient::Endpoints::Reviews.new(self, @routes[:reviews])
    end

    def request
      @request
    end

  end
end