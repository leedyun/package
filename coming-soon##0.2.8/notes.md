
Coming Soon Gem

1.	Plan the gem, imagine the interface
2.	Start with the project structure - google:
		how to build a gem
		make a gem using bundler (e.g bundle gem daily_deal); - watch the video
		how to build a cli gem
3.	Start with the entry point - the file run => bin/coming-soon
													#!/usr/bin/env ruby
													require ‘bundler/setup’
													require ‘coming_soon’
													ComingSoon::CLI.new.call   
							environment file => lib/coming_soon.rb
													require_relative '../config/environment'
														../config/environment						
															require_relative ‘./coming_soon /version’
															require_relative ‘./coming_soon /movies’
															require_relative ‘./coming_soon /cli’
4.	Force that to build the CLI interface => lib/coming_soon /cli.rb => ComingSoon::CLI
5.	Stub out the interface: list_movies => scrape data
							menu       	=> display menu of movies
							goodbye  	=> say goodbye

6.	Start making things real
7.	Discover objects
8.	Program

Example:

A command line interface for movies coming soon, starting with Fandango

•	User types coming-soon
•	Show a list of movies

1.	Guardians of the Galaxy Vol 2 – May 5
2.	The Lovers - May 5

Which movie do you want to learn more about?	 

1

What is a movie?

•	A movie has a name
•	A deal has a URL
•	A movie has a start date
•	A movie has a synopsis
