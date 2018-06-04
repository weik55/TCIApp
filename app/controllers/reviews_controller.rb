class ReviewsController < ApplicationController
	include Rails.application.routes.url_helpers

	#Presents a site that shows all the reivews in once place
	def index
	end

	#Shows one particular review
	def show
	end

	#A view that lets the user create a new review
	def new
	end

	#Create a new review based on parameters submitted
	def create
		render plain: params[:review].inspect
	end

	#Find a particular review and send the user to editing view
	def edit
	end

	#Update a particular review
	def update
	end

	#Delete a particualr review
	def destroy
	end

	private
		def article_params
			params.require(:review).permit(:movie_id, :title, :email, :comment)
		end
end
