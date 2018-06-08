# Controller for Movie article objects

# Note: I could have created an explicit movie model/object class and mapped incoming requests
# to an explicit movie object, but since JSON itself is already an object, doing so here
# would be a slightly wasted effort. The advantage of doing the former would be to implement
# a kind of interface for the object that you can check whether or not attributes existed, but
# since you can't guarentee the data you recieve, you'll still have to validate attributes and 
# answer the question of what to do with an invalid object after you create the object. 
# For now, we will assume that the external server is nice, trusted, and not prone to change.
class MoviesController < ApplicationController

	# Presents the default view of veiwing a list of movie objects
	def index
		mr = MovieRetriever.new

		@page = 1
		if params[:page] && params[:page].to_i >= 2
			@page = params[:page].to_i
		end

		if params[:sort_by] == "title"
			@movies = mr.load_movie_details(mr.get_by_title(@page))
		elsif params[:sort_by] == "date" && params[:year]
			@movies = mr.load_movie_details(mr.get_by_year(params[:year], @page))
		elsif params[:sort_by] == "genre" && params[:genre]
			@movies = mr.load_movie_details(mr.get_by_genre(params[:genre], @page))
		else
			@movies = mr.load_movie_details(mr.get_in_theaters)
		end
		@poster = mr.poster_config(2)
		@genres = mr.get_genres.invert
	end

	# Shows on particular movie object 
	def show
		mr = MovieRetriever.new
		@movie = mr.get_movie(params[:id])
		@movie["ratings"] = Rating.by_movie(params[:id])

		if params["page"]
			if params["page"].to_i >= 2
				@movie["reviews"] = Review.by_movie(params[:id], params["page"].to_i)
			else
				@movie["reviews"] = Review.by_movie(params[:id])
			end

			if  Review.by_movie(@movie["id"], params["page"].to_i + 1).size >= 1
				@movie["more_reviews"] = true
			else 
				@movie["more_reviews"] = false
			end
		end

		@poster = mr.poster_config(3)
		if @movie["title"] == nil
			render plain: "Uhhh your movie doesn't seem to exist in the database. Maybe we took a wrong turn at Albuquerque..."
		end
	end

end


