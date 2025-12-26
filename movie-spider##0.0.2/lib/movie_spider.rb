require "movie_spider/version"
require "movie_spider/douban_fetcher"
require "movie_spider/mtime_fetcher"
require 'json'
require 'open-uri'

module MovieSpider

  def self.fetch_stills(id, source, img_size="img_1000")
    case source
    when /douban/
      DoubanMovie.douban_movie_stills(id)
    when /mtime/
      MtimeMovie.mtime_movie_stills(id, img_size)
    when /all/
      DoubanMovie.douban_movie_stills(id) + MtimeMovie.mtime_movie.stills(id, img_size)
    end
  end

  def self.fetch_posters(id, source, img_size="img_1000")
    case source
    when /douban/
      DoubanMovie.douban_movie_posters(id)
    when /mtime/
      MtimeMovie.mtime_movie_posters(id, img_size)
    when /all/
      DoubanMovie.douban_movie_posters(id) + MtimeMovie.mtime_movie_posters(id, img_size)
    end
  end

  def self.fetch_info(id, source)
    case source
    when /douban/
      DoubanMovie.douban_movie_info(id)
    when /mtime/
      MtimeMovie.mtime_movie_info(id)
    end
  end

  def self.search_movies(title, source)
    case source
    when /douban/
      DoubanMovie.douban_search_movies(title)
    when /mtime/
      MtimeMovie.mtime_search_movies(title)
    end
  end

  def self.get_id_from_title(title, year, source="douban")
    year = year.to_i
    subjects = search_movies(title, source)
    match = []
    unless subjects.empty?
      subjects.each do |subject|
        film_name = title.gsub(/\[.+\]/, "").gsub("（", "(").gsub("）",")")
        if subject["year"].to_i == year and
          string_similarity(film_name, subject["title"], 0.8)
          match << subject['id']
        end
      end
    end
    match[0]
  end

  def self.define_component(type, source)
    define_singleton_method("fetch_#{type}_from_#{source}") do |id_or_title, year=Time.now.year|
      if id_or_title.to_i.to_s == id_or_title
        MovieSpider.send("fetch_#{type}", id_or_title, source)
      else
        id = get_id_from_title(id_or_title, year, source)
        MovieSpider.send("fetch_#{type}", id, source)
      end
    end
  end

  define_component "stills", "douban"
  define_component "stills", "mtime"
  define_component "posters", "douban"
  define_component "posters", "mtime"
  define_component "info", "douban"
  define_component "info", "mtime"

  private

  def self.string_similarity(origin, compare, score)
    origin.downcase!
    origin_pair = (0..origin.length-2).collect{|i| origin[i, 2]}.reject{|pair| pair.include? " "}
    compare.downcase!
    compare_pair = (0..compare.length-2).collect{|i| compare[i, 2]}.reject{|pair| pair.include? " "}

    union = origin_pair.size + compare_pair.size
    intersection = 0 
    origin_pair.each do |op|
      0.upto(compare_pair.size - 1) do |i|
        if op == compare_pair[i]
          intersection += 1
          compare_pair.slice!(i)
          break
        end
      end
    end 
    (2.0 * intersection) / union > score
  end

end
