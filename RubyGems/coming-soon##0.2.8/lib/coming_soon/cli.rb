class ComingSoon::CLI

	def call

		puts ''
		puts '               **************************'
		puts '               |   Movies Coming Soon   |'
		puts '               |     --------------     |'
		puts '               |      Please wait!      |'
		puts '               **************************'
		puts ''

		ComingSoon::Scraper.new.scrape_movies
		get_and_list_movies		
		menu_selection

	end

	def get_and_list_movies
		
		ComingSoon::Movie.movies.each.with_index(1) do |movie, i| # set the first index to 1 and use the index number for the movie number
			if i < 10
				spacer = ' '
			else
				spacer = ''
			end		
			puts "#{spacer}#{i}. #{movie.name} - #{movie.start_date}"
		end

	end

	def list_saved_movies

		puts ''
		puts '               **************************'
		puts '               |   Movies Coming Soon   |'
		puts '               **************************'
		puts ''

		ComingSoon::Movie.movies.each.with_index(1) do |movie, i| # set the first index to 1 and use the index number for the movie number
			puts "#{i}. #{movie.name} - #{movie.start_date}"
		end

	end

	def menu_selection

		input = ''

		while input != 'exit'
			puts ''
			puts 'You may enter a movie number for more details or "list" to see the menu again or "exit"'

			input = gets.strip.downcase

			if input.to_i > 0 && input.to_i < ComingSoon::Movie.movies.size+1
				puts "* #{ComingSoon::Movie.movies[input.to_i - 1].name} - #{ComingSoon::Movie.movies[input.to_i - 1].start_date} *"
				puts ComingSoon::Movie.movies[input.to_i - 1].synopsis	
			elsif input == 'list'
				list_saved_movies
			elsif input == 'exit'
				goodbye	
			else
				puts 'Invalid selection!'
				menu_selection
			end	
		end

	end

	def goodbye

		puts ''
		puts '               ***************************'
		puts '               |  Thank you and goodbye  |'
		puts '               |    -----------------    |'
		puts '               |     Come back soon!     |'
		puts '               ***************************'
		puts ''

		exit
		
	end

end	
