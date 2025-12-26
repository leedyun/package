
class ComingSoon::Movie
	attr_accessor :name, :start_date, :url, :synopsis

	def self.movies

		self.scrape_movies

		@movies

	end

	def self.scrape_movies

		doc = Nokogiri::HTML(open("http://www.fandango.com/moviescomingsoon"))
		# name: doc.css("li.visual-item a.visual-title").text.strip
		# start_date: doc.css("li.visual-item span").text
		# url: doc.css("li.visual-item a").attribute("href").value

		movie_list = doc.css("li.visual-item")
		@movies = []
		count = 1

		movie_list.each do |movie|
			@soon = self.new
			@soon.name = movie.css("a.visual-title").text.strip
			@soon.start_date = movie.css("span").text
			@soon.url = movie.css("a").attribute("href").value

			self.scrape_synopsis

			@movies << @soon

			count+=1
			if count > 20 # Displays only 20 movies
				break
			end
		end
		
	end

	def self.scrape_synopsis

		redirect_failed = false

		begin
			@doc_synop1 = Nokogiri::HTML(open(@soon.url)) # Uses the HTTP 'movieoverview' url
		rescue
			redirect_failed = true # An HTTP to HTTPS redirect failed
		end
		
		if !@doc_synop1.css("a.movie-synopsis-link").any? && !redirect_failed &&
			@doc_synop1.css("span#SynopsisTextLabel").any?
			# If not a redirect failure and a READ FULL SYNOPSIS link is not
			# present and any text is available, use the text for the synopsis
			@soon.synopsis = @doc_synop1.css("span#SynopsisTextLabel").text
		else
			# scrape the synopsis using the HTTP 'plotsummary' url
			synop_url = @soon.url.sub(/movieoverview/, 'plotsummary')
			doc_synop2 = Nokogiri::HTML(open(synop_url))
			@soon.synopsis = doc_synop2.css("p.subpage-descriptive-content").text
		end

	end

end
