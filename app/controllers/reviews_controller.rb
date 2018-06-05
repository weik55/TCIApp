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
	end

	# Shows one particular review
	def show
	end

	# A view that lets the user create a new review
	def new
	end

	# Create a new review based on parameters submitted
	def create
		render plain: params[:user].inspect + params[:review].inspect + params[:movie_id].inspect
	end

	# Find a particular review and send the user to editing view
	def edit
	end

	# Update a particular review
	def update
	end

	# Delete a particualr review
	def destroy
	end

	private
		def article_params
			params.require(:user).permit(:email)
			params.require(:review).permit(:movie_id, :rating, :comment)
		end
end
