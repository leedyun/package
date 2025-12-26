# coding: utf-8

module MovieSpider
  module DoubanMovie

    UrlPrefix = "http://api.douban.com/v2/"
    Key = "0c89712b2297db4e259c538167c791ea"

    def self.douban_movie_info(movie_id)
      path = "movie/subject/#{movie_id}?apikey=#{Key}"
      data = api_get(path)
      subject ={}
      subject['id'] = data['id']
      subject['title'] = data['title']
      subject['alt'] = data['alt']
      subject['original_title'] = data['original_title']
      subject['year'] = data['year']
      subject['genres'] = data['genres']
      subject['length'] = nil
      subject['area'] = data['countries'].join("|")
      subject['directors'] = data['directors'].map { |e| e['name'] }
      subject['actors'] = data['casts'].map { |e| e['name'] }
      subject['summary'] = data['summary'].gsub("©豆瓣", "")
      subject['rating'] = data['rating']['average']
      subject
    end

    def self.douban_search_movies(movie_name)
      movie_name = movie_name.gsub(/\[.+\]/, "")
      path = "movie/search?q=#{movie_name}&apikey=#{Key}"
      api_get(path)["subjects"].map do |subject|
        subject.delete_if { |key,value| not %w|id year title|.include? key }
      end
    end

    def self.douban_movie_stills(douban_id)
      fetch_img("http://movie.douban.com/subject/#{douban_id}/photos?type=S&start=0&sortby=vote&size=a&subtype=o")
    end

    def self.douban_movie_posters(douban_id)
      fetch_img("http://movie.douban.com/subject/#{douban_id}/photos?type=R&start=0&sortby=vote&size=a&subtype=a")
    end

    private

    def self.api_get(path)
      begin
        data = RestClient.get URI.encode(UrlPrefix + path)
        JSON.parse data
      rescue Timeout::Error => e  
        ExceptionNotifier::Notifier.background_exception_notification(e).deliver
        Rails.logger.error "获取豆瓣API: #{UrlPrefix}movie/search?q=#{movie_name}超时出错..."
      rescue JSON::JSONError => e
        ExceptionNotifier::Notifier.background_exception_notification(e).deliver
        Rails.logger.error "获取豆瓣API: #{UrlPrefix}movie/suject/#{movie_id}数据JSON.parse出错..."
      end
    end

    def self.fetch_img(url) 
      begin
        doc = Nokogiri::HTML(open(url))
      rescue
        return []
      end
      as = doc.css("ul li div.cover a")
      photos = []
      as.each do |a|
        photos << a.css("img").first.attributes["src"].value.sub("thumb", "photo") rescue next
      end
      if doc.css("span.next a").first.present?
        url = doc.css("span.next a").first.attributes["href"].value
        photos = photos + fetch_img(url)
      end
      photos.uniq
    end

  end
end