# A class that controls the inputs and outputs of the homepage (Home)
# To the reviewer: It may have been better to install a MovieDB wrapper as a gem to speed up production
# of this app. However, I decided to instead to use the Net::HTTP protocols included just to show that I can.

#TODO: Test Ping Database to see if it works on startup
#TODO: Tests

class HomeController < ApplicationController

	#Method that retrieves the nessassary information for the homepage
	def index
		mr = MovieRetriever.new
		@movies = mr.load_movie_details(mr.get_in_theaters)
		@upcoming = mr.get_upcoming
		@poster = mr.poster_config(2)
		@side_reviews = Review.recent(3)
	end

end
