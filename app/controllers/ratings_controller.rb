# A class that controls the inputs and outputs of ratings

# Ordinarily this would be hidden behind some log in for admin use.

class RatingsController < ApplicationController
	include Rails.application.routes.url_helpers

	# Presents a site that shows all the reivews in once place
	def index
		@ratings = Rating.all
	end

	# Delete all the ratings data for a particular movie
	def destroy
		@review = Review.find(params[:id])
		@review.destroy

		redirect_to ratings_path
	end
end
