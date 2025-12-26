class ComingSoon::Scraper

	def scrape_movies

		doc = Nokogiri::HTML(open("http://www.fandango.com/moviescomingsoon"))
		# name: doc.css("li.visual-item a.visual-title").text.strip
		# start_date: doc.css("li.visual-item span").text
		# url: doc.css("li.visual-item a").attribute("href").value

		movie_list = doc.css("li.visual-item")
		
		count = 0

		movie_list.each do |movie| 
			soon = ComingSoon::Movie.new
			soon.name = movie.css("a.visual-title").text.strip
			soon.start_date = movie.css("span").text
			soon.url = movie.css("a").attribute("href").value

			scrape_details(soon)

			count+=1
			if count > 19 # Scrapes only 20 movies
				break
			end
		end
		
	end

	def scrape_details(soon)
		
		redirect_failed = false

		begin
			doc_synop1 = Nokogiri::HTML(open(soon.url)) # Uses the HTTP 'movieoverview' url
		rescue
			redirect_failed = true # A HTTP to HTTPS redirect failed
		end

		if !redirect_failed
			if !doc_synop1.css("a.movie-synopsis-link").any? &&
				doc_synop1.css("span#SynopsisTextLabel").any?
				# If a READ FULL SYNOPSIS link is not present and any
				# text is available, use that text for the synopsis
				soon.synopsis = doc_synop1.css("span#SynopsisTextLabel").text
			else
				scrape_plotsummary(soon)
			end
		else
			scrape_plotsummary(soon)
		end

	end

	def scrape_plotsummary(soon)
		# Scrape the synopsis using the HTTP 'plotsummary' url
		# This is also executed after an HTTP to HTTPS redirect failed
		synop_url = soon.url.sub(/movieoverview/, 'plotsummary')
		doc_synop2 = Nokogiri::HTML(open(synop_url))
		soon.synopsis = doc_synop2.css("p.subpage-descriptive-content").text
		
	end

end
