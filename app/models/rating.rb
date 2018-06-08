# The Rating Model Object
class Rating < ApplicationRecord
	validates :movie_id, presence: true

	#Maps a given score of a movie to a column
	alias_attribute "1", :one_star
	alias_attribute "2", :two_star
	alias_attribute "3", :three_star
	alias_attribute "4", :four_star
	alias_attribute "5", :five_star

	class << self
		# Fetches the rating by a Movie ID
		def by_movie(movie_id)
	    	where(movie_id: movie_id).first
	    end
	end

	# Returns the counts of a given column
	def get_star_count(stars)
		if stars == "1" || stars == 1
			if one_star
				one_star
			else
				0
			end
		elsif stars == "2" || stars == 2
			if two_star
				two_star
			else
				0
			end
		elsif stars == "3" || stars == 3
			if three_star
				three_star
			else
				0
			end
		elsif stars == "4" || stars == 4
			if four_star
				four_star
			else
				0
			end
		else stars == "5" || stars == 5
			if five_star
				five_star
			else
				0
			end
		end
	end

	# Averages the scores given in the columns
	def average_of_all
		sum = 0
		(1..5).each do |i|
			sum += (i * get_star_count(i))
		end
		result = (sum + 0.0) / total_count
	end

	# Tallies the total amount of scores given
	def total_count
		sum = 0
		(1..5).each do |i|
			sum += get_star_count(i)
		end
		return sum
	end
end
