# A class that helps retrieve lists and movies from MovieDB
class MovieRetriever
	require "net/http"
	BASE_URL = "https://api.themoviedb.org/3/"
	IMG_URL = "http://image.tmdb.org/t/p/"

	@@poster_sizes = ["w92", "w154", "w185","w342","w500","w780","original"] 	#Hard code in the sizes for now, turn this into auto population later
	@@backdrop_sizes = ["w300", "w780", "w1280", "original"]

	# Initializes the class with default variables
	def initialize
		@api_key = "?api_key=" + Keys.mdb_api
		@def_config = "http://image.tmdb.org/t/p/w154/"
	end

	# Returns the server poster configuration for a chosen size (int)
	def poster_config (size)
		config = IMG_URL + @@poster_sizes[size] + "/"
		return config
	end

	# Returns the server backdrop configuration for a chosen size (int)
	def backdrop_config (size)
		config = IMG_URL + @@backdrop_sizes[size] + "/"
		return config
	end

	# Retrieves the current configuration of the database server
	def get_serv_config
		action = "configuration"
		response = call_api(action)
	end

	# Retrieves the first page of a list of movies currently in theaters
	def get_in_theaters
		action = "movie/now_playing"
		argument = "&language=en-US&page=1"
		response = call_api(action, argument)
		movies = process_results(response["results"])
		return movies
	end

	# Retrieves the first page of a list of movies that are upcoming
	def get_upcoming
		action = "discover/movie"
		today = Date.today.to_s
		next_month = Date.today.advance(:months => 1).to_s
		argument = "&include_adult=false&primary_release_date.gte=" + today + "&primary_release_date.lte=" + next_month
		response = call_api(action, argument)
		movies = process_results(response["results"])
		return movies
	end

	# Retrieves the a list of movies sorted by title alphabetically
	def get_by_title (page = 1)
		action = "discover/movie"
		argument = "&sort_by=original_title.asc" + "&page=" + page.to_s
		response = call_api(action, argument)
		movies = process_results(response["results"])
		return movies
	end

	# Retrieves the a list of movies sorted by year and then most recent
	def get_by_year (year, page = 1)
		action = "discover/movie"
		argument = "&sort_by=release_date.desc" + "&year=" + year + "&page=" + page.to_s
		response = call_api(action, argument)
		movies = process_results(response["results"])
		return movies
	end

	# Retrieves the information of one movie
	def get_movie (id)
		action = "movie/" + id
		argument = "&language=en-US"
		response = call_api(action, argument)
		movie = process_result(response)
		return response
	end

	# General method to call the api of the movie database
	def call_api (action, argument = "")
		uri_str = BASE_URL + action + @api_key + argument
		uri = URI.parse(uri_str)
		response = Net::HTTP.get_response(uri)
		#check response
		response_body = JSON.parse(response.body)
		return response_body
	end

	# Loads the movie ratings and reviews from our database
	def MovieRetriever.load_movie_details (movies)
		movies.each do |movie|
			movie["ratings"] = Rating.by_movie(movie["id"])
			if Review.by_movie(movie["id"]).size <= 7
				movie["reviews"] = Review.by_movie(movie["id"])
				movie["more_reviews"] = false
			else 
				movie["reviews"] = Review.by_movie(movie["id"]).first(7)
				movie["more_reviews"] = true
			end
		end
		return movies
	end
	
	private 

		def process_results (results)
			results.each do |result|
				result = process_result(result)
			end
			return results
		end

		def process_result (result)
			if result["release_date"] && !result["release_date"].eql?("")
				date_obj = Date.parse(result["release_date"])
				result["date"] = date_obj.to_formatted_s(:long)
			else 
				result["date"] = "None"
			end
			return result
		end
end 