# A class that controlls the inputs and outputs of the homepage (Home)
# To the reviewer: I could have installed a MovieDB wrapper as a gem to speed up production
# of this app. However, I decided to instead to use the Net::HTTP calls just to show that I can.

#TODO: Add stars
#TODO: Make a "Movie" Class Object.
#TODO: Test Ping Database to see if it works on startup
#TODO: Get configuration and genre look-ups and store them on startup
#TODO: Create individual pages for each movie.
#TODO: Make a search
class HomeController < ApplicationController
	require "net/http"
	require "uri"

	def index
		key = Keys.new

		base_url = "https://api.themoviedb.org/3/"
		api_key = "?api_key=" + key.mdb_api
		#action = "configuration"
		#argument = ""
		#response1 = Net::HTTP.get_response(uri1)
		puts "Requesting movies from external database..."
		action = "discover/movie"
		argument = "&primary_release_date.gte=2018-04-01&primary_release_date.lte=2018-06-01"
		uri_str = base_url + action + api_key + argument
		uri = URI.parse(uri_str)
		response = Net::HTTP.get_response(uri)
		@config = "http://image.tmdb.org/t/p/w154/"

		response_body = JSON.parse(response.body)
		@movies = response_body["results"]
		@movies.each do |movie|
			parsedDate = Date.parse(movie["release_date"])
			movie["date"] = parsedDate.to_formatted_s(:long)
		end
  		#@config_as_text = response1.body
  		@movie_as_text = response.body
	end
end
