# A class that helps retrieve lists and movies from MovieDB
class MovieRetriever
	require "net/http"
	BASE_URL = "https://api.themoviedb.org/3/"

	# Initializes the class with default variables
	def initialize
		@api_key = "?api_key=" + ENV['MDB_API']
		@def_config = "http://image.tmdb.org/t/p/w154/"
	end

	# Returns the server poster configuration for a chosen size (int)
	def poster_config (size)
		config = get_config_for("base_url") + get_config_for("poster_sizes")[size] + "/"
	end

	# Returns the server backdrop configuration for a chosen size (int)
	def backdrop_config (size)
		config = get_config_for("base_url") +  get_config_for("backdrop_sizes")[size] + "/"
	end

	# Returns the config for a specified key
	def get_config_for (type)
		current_config = server_config
		config = server_config["images"][type]
	end

	# Retrieves the current configuration of the database server from the server
	def get_serv_config
		action = "configuration"
		response = call_api(action)
	end

	# Returns the current cached configuration, else retrieve it from the server
	def server_config
    	Rails.cache.fetch("tmdb/server_config", expires_in: 24.hours) do
    		get_serv_config
		end
	end

	# Returns the current cached genre map, else retrieve it from the server
	def get_genres
    	Rails.cache.fetch("tmdb/genres_list", expires_in: 24.hours) do
    		action = "genre/movie/list"
    		argument = "&language=en-US"
			response = call_api(action, argument)
			@result = Hash.new
			response["genres"].each do |genre|
				@result[genre["id"]] = genre["name"]
			end
			@result
		end
	end

	# Retrieves the first page of a list of movies currently in theaters
	def get_in_theaters
		action = "movie/now_playing"
		argument = "&language=en-US&page=1"
		response = call_api(action, argument)
		movies = process_results(response["results"])
	end

	# Retrieves the first page of a list of movies that are upcoming
	def get_upcoming
		action = "discover/movie"
		today = Date.today.to_s
		next_month = Date.today.advance(:months => 1).to_s
		argument = "&include_adult=false&primary_release_date.gte=" + today + "&primary_release_date.lte=" + next_month
		response = call_api(action, argument)
		movies = process_results(response["results"])
	end

	# Retrieves the a list of movies sorted by title alphabetically
	def get_by_title (page = 1)
		action = "discover/movie"
		argument = "&sort_by=original_title.asc" + "&page=" + page.to_s
		response = call_api(action, argument)
		movies = process_results(response["results"])
	end

	# Retrieves the a list of movies sorted by year and then most recent
	def get_by_year (year, page = 1)
		action = "discover/movie"
		argument = "&sort_by=release_date.desc" + "&year=" + year + "&page=" + page.to_s
		response = call_api(action, argument)
		movies = process_results(response["results"])
	end

	# Retrieves the a list of movies sorted by genre
	def get_by_genre (genre, page = 1)
		action = "discover/movie"
		argument = "&with_genres=" + genre + "&page=" + page.to_s
		response = call_api(action, argument)
		movies = process_results(response["results"])
	end

	# Retrieves the information of one movie
	def get_movie (id)
		action = "movie/" + id
		argument = "&language=en-US"
		response = call_api(action, argument)
		movie = process_result(response)
	end

	# General method to call the api of the movie database
	def call_api (action, argument = "")
		uri_str = BASE_URL + action + @api_key + argument
		uri = URI.parse(uri_str)
		response = Net::HTTP.get_response(uri)
		#check response
		response_body = JSON.parse(response.body)
	end

	# Loads the movie ratings and reviews from our database
	def load_movie_details (movies)
		movies.each do |movie|
			load_ratings(movie)
			load_reviews(movie)
			load_genres(movie)
		end
		return movies
	end

	# Loads the ratings of a specified movie
	def load_ratings (movie)
		movie["ratings"] = Rating.by_movie(movie["id"])
	end

	# Loads the reviews of a specified movie
	def load_reviews (movie)
		movie["reviews"] = Review.by_movie_quick(movie["id"])
		if Review.by_movie(movie["id"]).size <= 7
			movie["more_reviews"] = false
		else 
			movie["more_reviews"] = true
		end
	end

	# Loads the genres of the specified movie
	def load_genres (movie) 
		movie["genres"] = Hash.new
		movie["genre_ids"].each do |id|
			movie["genres"][id] = get_genres[id]
		end
	end
	
	private 

		# Processes the a list of results of a movie
		def process_results (results)
			results.each do |result|
				result = process_result(result)
			end
			return results
		end

		# Processes the result of a movie to change the dates to be more legible, could be extended for other processing
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