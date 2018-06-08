require 'test_helper'

class MoviesControllerTest < ActionDispatch::IntegrationTest
 	test "should get movies index" do
 		get movies_url
    	assert_response :success
 	end

 	test "should get movies index after query by title" do
 		get movies_url, params: { sort_by: "title" }
    	assert_response :success
 	end

 	test "should get movies by title, more pages" do
 		get movies_url, params: { sort_by: "title", page: "3" }
    	assert_response :success
 	end

 	test "should handle movies by title, at negative pages" do
 		get movies_url, params: { sort_by: "title", page: "-3" }
    	assert_response :success
 	end

 	test "should get movies index after query by date" do
 		get movies_url, params: { sort_by: "date" }
    	assert_response :success
 	end

 	test "should get movies index after query by genre" do
 		get movies_url, params: { sort_by: "genre" }
    	assert_response :success
 	end

 	test "should get one movie in show" do
 		get movie_url(:id => 351286)
    	assert_response :success
 	end

 	test "should handle undefined movie" do
 		get movie_path("1ra25")
    	assert_response :success
 	end

end
