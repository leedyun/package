# coding: utf-8
module MovieSpider
  module MtimeMovie
    # 时光剧照
    def self.mtime_movie_stills(movie_id, img_size)
      parse_mtime(movie_id, "officialstageimage", img_size)
    end
    # 时光海报
    def self.mtime_movie_posters(movie_id, img_size)
      posters = parse_mtime(movie_id, "generalposter", img_size) \
                + parse_mtime(movie_id, "forecastposter", img_size) \
                + parse_mtime(movie_id, "roleposter", img_size)
      posters.delete(nil)
      posters.delete("")
      posters
    end
    # 时光信息
    def self.mtime_movie_info(movie_id)
      subject = {}
      begin
        html_doc = Nokogiri::HTML(open("http://movie.mtime.com/#{movie_id}/"))
        plots = Nokogiri::HTML(open("http://movie.mtime.com/#{movie_id}/plots.html"))
      rescue
        return subject
      end
      subject['id'] = movie_id.to_s
      subject['title'] = html_doc.css(".db_head h1").text
      subject['alt'] = "http://movie.mtime.com/#{movie_id}/"
      subject['original_title'] = html_doc.css(".db_head .db_enname").text
      subject['year'] = html_doc.css(".db_head .db_year").text.gsub(/[\(\)]/, "")
      subject['genres'] = html_doc.css(".db_head a[property='v:genre']").map { |e| e.text }
      subject['length'] = html_doc.css(".db_head span[property='v:runtime']").text
      subject['area'] = html_doc.css("dl.info_l dd")[2].css("a").text
      subject['directors'] = html_doc.css(".db_contout a[rel='v:directedBy']").map { |e| e.text }
      subject['actors'] = html_doc.css("dl.main_actor a[pan][title]").map { |e| e['title']}
      subject['summary'] = plots.css("div.plots_box").text.strip
      subject['rating'] = mtime_rating(movie_id)
      subject
    end
    # 使用电影标题搜索时光网电影信息，返回数组
    def self.mtime_search_movies(movie_title)
      search_result = mtime_search(movie_title)['value']['movieResult']
      direct_subject = search_result['directMovie']
      subjects = search_result['moreMovies']
      # 合并结果，去除空值
      unless subjects.nil?
        subjects.insert(0,direct_subject).delete({})
      else
        subjects = direct_subject.empty? ? [] : [direct_subject]
      end
      subjects.map do |subject|
        item = {}
        subject['movieTitle'] =~ /\((.*)\)/
        item['id'] = subject['movieId'].to_s
        item['title'] = subject['movieTitle'].split(" ")[0]
        item['year'] = $1
        subject.clear
        subject.update(item)
      end
      subjects
    end
    # 时光网评分
    def self.mtime_rating(movie_id)
      begin
        result_str = open("http://service.library.mtime.com/Movie.api?Ajax_CallBack=true&Ajax_CallBackType=Mtime.Library.Services&Ajax_CallBackMethod=GetMovieOverviewRating&Ajax_CrossDomain=1&Ajax_RequestUrl=http%3A%2F%2Fmovie.mtime.com%2F189691%2F&t=20153418472369218&Ajax_CallBackArgument0=#{movie_id}").read
      rescue
        puts "parse error"
        return ""
      end
      result_str.scan(/{.*}/) {|match| return JSON.parse(match)['value']['movieRating']['RatingFinal'].to_i}
    end

    private

    # 时光网搜索
    def self.mtime_search(movie_title)
      begin
        result_str = open(URI::encode("http://service.channel.mtime.com/Search.api?Ajax_CallBack=true&Ajax_CallBackType=Mtime.Channel.Services&Ajax_CallBackMethod=GetSearchResult&Ajax_CrossDomain=1&Ajax_RequestUrl=http%3A%2F%2Fsearch.mtime.com%2Fsearch%2F%3Fq%3D%25E8%25B6%2585%25E8%2583%25BD%25E9%2599%2586%25E6%2588%2598%25E9%2598%259F&t=20153414382422867&Ajax_CallBackArgument0=#{movie_title}&Ajax_CallBackArgument1=0&Ajax_CallBackArgument2=365&Ajax_CallBackArgument3=0&Ajax_CallBackArgument4=1")).read
      rescue
        puts "parse error"
        return ""
      end
      result_str.scan(/{.*}/) {|match| return JSON.parse(match)}
    end

    # 时光网图片解析
    def self.parse_mtime(movie_id, type, img_size)
      begin
        html_doc = Nokogiri::HTML(open("http://movie.mtime.com/#{movie_id}/posters_and_images/posters/hot.html"))
        parser = ""
        html_doc.css("body").search("script")[1].text.scan(/{"#{type}".*?}\]}/) {|match| parser = JSON.parse(match) }
        parser[type].map do |item|
          item[img_size]
        end
      rescue
        return []
      end
    end

  end
end