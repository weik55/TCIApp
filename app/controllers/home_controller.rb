# A class that controls the inputs and outputs of the homepage (Home)
# To the reviewer: It may have been better to install a MovieDB wrapper as a gem to speed up production
# of this app. However, I decided to instead to use the Net::HTTP protocols included just to show that I can.

#TODO: New database of histogram of reviews
#TODO: Test Ping Database to see if it works on startup
#TODO: Get configuration and genre look-ups and store them on startup
#TODO: Error handling
#TODO: Make a search
#TODO: Pagination for results
#TODO: Limit about of reviews you get for movies on the front page
#TODO: Prettify : reviews/index, reviews/id, reviews/new

class HomeController < ApplicationController

	#Method that retrieves the nessassary information for the homepage
	def index
		mr = MovieRetriever.new
		@movies = mr.get_in_theaters
		@movies.each do |movie|
			movie["reviews"] = Review.by_movie(movie["id"])
		end
		@upcoming = mr.get_upcoming
		@poster = mr.poster_config(2)
		@side_reviews = Review.recent(3)
	end
end
