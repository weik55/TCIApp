class MoviesController < ApplicationController
	def index
		mr = MovieRetriever.new
		@movies = mr.get_in_theaters
		@poster = mr.poster_config(1)
	end

	def show
		mr = MovieRetriever.new
		@movie = mr.get_movie(params[:id])
		@poster = mr.poster_config(3)
	end
end
