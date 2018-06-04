#A class that helps retrieve lists and movies from MovieDB
class MovieRetriever
	require "net/http"
	BASE_URL = "https://api.themoviedb.org/3/"
	IMG_URL = "http://image.tmdb.org/t/p/"

	@@poster_sizes = ["w92", "w154", "w185","w342","w500","w780","original"] 	#Hard code in the sizes for now, turn this into auto population later
	@@backdrop_sizes = ["w300", "w780", "w1280", "original"]

	#Initializes the class with default variables
	def initialize
		@api_key = "?api_key=" + Keys.mdb_api
		@def_config = "http://image.tmdb.org/t/p/w154/"
	end

	#Returns the server poster configuration for a chosen size (int)
	def poster_config (size)
		config = IMG_URL + @@poster_sizes[size] + "/"
		return config
	end

	#Returns the server backdrop configuration for a chosen size (int)
	def backdrop_config (size)
		config = IMG_URL + @@backdrop_sizes[size] + "/"
		return config
	end

	#Retrieves the current configuration of the database server
	def get_serv_config
		action = "configuration"
		response = call_api(action)
	end

	#Retrieves the first page of a list of movies currently in theaters
	def get_in_theaters
		action = "discover/movie"
		argument = "&primary_release_date.gte=2018-04-01&primary_release_date.lte=2018-06-01"
		response = call_api(action, argument)
		movies = response["results"]
		movies.each do |movie|
			movie["date"] = format_date(movie["release_date"])
		end
		return movies
	end

	#Retrieves the information of one movie
	def get_movie (id)
		action = "movie/" + id
		argument = "&language=en-US"
		response = call_api(action, argument)
		response["date"] = format_date(response["release_date"])
		return response
	end

	#General method to call the api of the movie database
	def call_api (action, argument = "")
		uri_str = BASE_URL + action + @api_key + argument
		uri = URI.parse(uri_str)
		response = Net::HTTP.get_response(uri)
		#check response
		response_body = JSON.parse(response.body)
		return response_body
	end

	private 
		#Helper method to return dates in normal written format
		def format_date(date)
			date_obj = Date.parse(date)
			formatted = date_obj.to_formatted_s(:long)
			return formatted
		end
end 