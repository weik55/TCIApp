require 'test_helper'

# Most of my tests for saving and retrieving were included in the controller
# Granular tests here doesn't seem to work against my test database
class RatingTest < ActiveSupport::TestCase

	test "Find a rating by movie" do
  		rating = Rating.by_movie(323)
  		assert rating
	end

	test "Accurately count stars" do
  		rating = Rating.by_movie(66864)
  		assert rating.get_star_count(3) == 15
	end

	test "Accurately averages rating" do
  		rating = Rating.by_movie(1)
  		assert rating.average_of_all == 3.0
	end
end
