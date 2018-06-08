# The Review Model Object
class Review < ApplicationRecord
	validates :movie_id, presence: true
	validates :movie_title, presence: true
	validates :rating, presence: true
	validates :email, presence: true
	
	class << self

		# Returns the results in order of created date
		def in_order
	    	order(created_at: :asc)
	    end

	    # Returns the results in reverse order of created date
	    def rev_order
	    	order(created_at: :desc)
	    end

	    # Returns the n most recent results
	    def recent(n)
	    	in_order.endmost(n)
	    end

	    # Returns the last n results of a query
	    def endmost(n)
	    	all.only(:order).from(all.reverse_order.limit(n), table_name)
	    end

	    # Finds all reviews from the specified movie
	    def by_movie(movie_id, page = 1)
	    	diff = (page - 1) * 10
	    	where(movie_id: movie_id).rev_order.offset(diff).limit(10)
	    end

	    # Only returns the first 7 reviews found for a movie
	    def by_movie_quick(movie_id)
	    	by_movie(movie_id).first(7)
	    end

	    # Returns the specified page of reviews
	    def page (page = 1)
	    	diff = (page - 1) * 10
	    	all.offset(diff).limit(10)
	    end
	end
end
