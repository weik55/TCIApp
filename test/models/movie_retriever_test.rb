require 'test_helper'

# Due to the nature of the external api, I can't test ping it over and over, so i've only written a test to see if the server responds
class MovieRetrieverTest < ActiveSupport::TestCase
	test "initializes" do
 		mr = MovieRetriever.new
    	assert mr
 	end

 	test "the external server responds" do
 		mr = MovieRetriever.new
 		response = mr.get_serv_config
    	assert_not response.empty?
 	end
end
