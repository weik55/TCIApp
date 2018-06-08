# A class that controls the inputs and outputs of ratings

# Ordinarily this would be hidden behind some login for admin use.
# The same warnings for reviews_controller applies here

class RatingsController < ApplicationController
	include Rails.application.routes.url_helpers

	# Presents a site that shows all the reivews in once place
	def index
		@ratings = Rating.all
	end

	# Delete all the ratings data for a particular movie
	# Currently not hooked up to a route, so that it cannot be accidentally destoryed yet
	def destroy
		@review = Review.find(params[:id])
		@review.destroy

		redirect_to ratings_path
	end

	# Saves ratings into the database
	def RatingsController.save_rating (params)
		@rating = Rating.by_movie(params[:review][:movie_id]);
		if @rating
			update_rating(@rating, params)
		else
			create_rating(params)
		end
	end

	protected
		# Updates the rating.
		# Note: Not part of the the RESTful API, so it has it's own method. Only internal calls allowed
		def self.update_rating (rating, params)
			star_rating = params[:review][:rating]
			rating.update(star_rating => (rating.get_star_count(star_rating) + 1))
			rating.update(avg: rating.average_of_all)
		end

		# Creates a new rating
		# Note: Not part of the the RESTful API, so it has it's own method. Only internal calls allowed
		def self.create_rating (params)
			star_rating = params[:review][:rating]
			rating = Rating.new(params.require(:review).permit(:movie_id).merge(star_rating => 1, avg: star_rating))
			rating.save
		end
end
