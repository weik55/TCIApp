require 'test_helper'

class AboutControllerTest < ActionDispatch::IntegrationTest
 	test "about index" do
 		get about_url
    	assert_response :success
 	end
end
