class Review < ApplicationRecord
	validates :movie_id, presence: true
	validates :movie_title, presence: true
	validates :rating, presence: true
	validates :email, presence: true
	
	class << self
		def in_order
	      order(created_at: :asc)
	    end

	    def rev_order
	      order(created_at: :desc)
	    end

	    def recent(n)
	      in_order.endmost(n)
	    end

	    def endmost(n)
	      all.only(:order).from(all.reverse_order.limit(n), table_name)
	    end

	    #Finds all reviews from the specified movie
	    #TODO: Limit front page results to like 5
	    def by_movie(movie_id)
	    	where(movie_id: movie_id).rev_order
	    end
	end
end
