# A class that controls the RESTful inputs/outputs of user reviews

# Warning!
# The methods that create, alter, or delete an object from a table only have basic safeguards and validations
# Some validations are built into Rails and can be used by following the best practices
# Importantly: these methods currently
	# -Do not check if hidden fields have been tampered with
	# -Do not check for session id's to prevent 3rd party interceptions
	# -Do not store e-mails as an encrypted hash
# For now, we make the following assumumptions
	# - The user is trustworthy, and won't tamper with random fields
	# - 3rd parties are not malicious.
	# - Basic user privacy is fine because we do not validate e-mails anyway
# A stronger security is a task that I have decided to not include in the scope of this project
class ReviewsController < ApplicationController
	include Rails.application.routes.url_helpers

	# Presents a site that shows all the reivews in once place
	def index
		@has_more = false
		@has_prev = false

		if params["page"] && params["page"].to_i >= 2
			@reviews = Review.page(params["page"].to_i)
		else
			@reviews = Review.page
		end

		if params["page"] && Review.page(params["page"].to_i + 1).size >= 1
			@next_page = params["page"].to_i + 1
			@has_more = true
		elsif !params["page"] && Review.page(2).size >= 1
			@next_page = 2
			@has_more = true
		end

		if params["page"] && params["page"].to_i >= 1
			@has_prev = true
		end
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

		if @review.save && RatingsController.save_rating(params)
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
