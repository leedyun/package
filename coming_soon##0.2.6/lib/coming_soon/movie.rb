
class ComingSoon::Movie
	attr_accessor :name, :start_date, :url, :synopsis

	@@movies = []

	def initialize
		@@movies << self
	end	

	def self.movies
		@@movies
	end	

end
