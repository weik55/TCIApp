# A class that controls the inputs and outputs of the homepage (Home)
# To the reviewer: It may have been better to install a MovieDB wrapper as a gem to speed up production
# of this app. However, I decided to instead to use the Net::HTTP protocols included just to show that I can.

#TODO: Show and delete comments
#TODO: Add stars
#TODO: Test Ping Database to see if it works on startup
#TODO: Get configuration and genre look-ups and store them on startup
#TODO: Error handling
#TODO: Make a search
class HomeController < ApplicationController

	#Method that retrieves the nessassary information for the homepage
	def index
		mr = MovieRetriever.new
		@movies = mr.get_in_theaters
		@upcoming = mr.get_upcoming
		@poster = mr.poster_config(2)
	end

	#This is a method I used to help test certain functions of ruby on rails
	def test_index
		base_url = "https://api.themoviedb.org/3/"
		api_key = "?api_key=" + Keys.mdb_api

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
  		@movie_as_text = response.body
	end
end
