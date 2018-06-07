# A class that controls the inputs and outputs of the homepage (Home)
# To the reviewer: It may have been better to install a MovieDB wrapper as a gem to speed up production
# of this app. However, I decided to instead to use the Net::HTTP protocols included just to show that I can.

#TODO: Test Ping Database to see if it works on startup
#TODO: Get configuration and genre look-ups and store them on startup
#TODO: Error handling both on startup and false inputs by user on review page
#TODO: Get # of comments and then next page.
#TODO: Prettify reviews/id
#TODO: Get by release date (javascript)
#TODO: Get by genre (javascript)

class HomeController < ApplicationController

	#Method that retrieves the nessassary information for the homepage
	def index
		mr = MovieRetriever.new
		@movies = MovieRetriever.load_movie_details(mr.get_in_theaters)
		@upcoming = mr.get_upcoming
		@poster = mr.poster_config(2)
		@side_reviews = Review.recent(3)
	end

end
