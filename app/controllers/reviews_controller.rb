# A class that controls the RESTful inputs/outputs of user reviews

# Warning!
# The methods that create, alter, or delete an object from a table only have basic safeguards and validations
# Some validations are built into Rails and can be used by following the best practices
# Importantly: these methods currently
	# -Do not check if hidden fields have been tampered with
	# -Do not check for session id's to prevent 3rd party interceptions
	# -Do not store e-mails as an encrypted hash
# For now, we make the following assumumptions
	# - The user is trustworthy
	# - 3rd parties are not malicious.
	# - Basic user privacy is fine because we do not validate e-mails anyway
# A stronger security is a task that I have decided to not include in the scope of this project
class ReviewsController < ApplicationController
	include Rails.application.routes.url_helpers

	# Presents a site that shows all the reivews in once place
	def index
		@reviews = Review.all
	end

	# Shows one particular review
	def show
		@review = Review.find(params[:id])
	end

	# A view that lets the user create a new review
	def new
		@review = Review.new
	end

	# Create a new review based on parameters submitted
	def create
		@review = Review.new(review_params)
		@review.date = Date.today

		@rating = Rating.by_movie(params[:review][:movie_id]);
		star_rating = params[:review][:rating]
		if @rating
			@rating.update(star_rating => (@rating.get_star_count(star_rating) + 1))
			@rating.update(avg: @rating.average_of_all)
		else
			@rating = Rating.new(params.require(:review).permit(:movie_id).merge(star_rating => 1, avg: star_rating))
			@rating.save
		end

		if @review.save
			redirect_to @review
		else
			render 'new'
		end
	end

	# Delete a particualr review
	def destroy
		@review = Review.find(params[:id])
		@review.destroy

		redirect_to reviews_path
	end

	private
		def review_params
			params.require(:review).require(:movie_id)
			params.require(:review).require(:movie_title)
			params.require(:review).require(:rating)
			params.require(:user).require(:email)
			params.require(:review).permit(:movie_id, :movie_title, :rating, :comment).merge(params.require(:user).permit(:email))
		end
end
