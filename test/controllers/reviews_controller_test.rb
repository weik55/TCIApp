require 'test_helper'

class ReviewsControllerTest < ActionDispatch::IntegrationTest
 	
 	test "should get reviews index" do
 		get reviews_url
    	assert_response :success
 	end

 	test "reviews index should handle greater than max pages" do
 		get reviews_url params: { page: "1000" }
    	assert_response :success
 	end

 	test "reviews index should handle less than min pages" do
 		get reviews_url params: { page: "-33" }
    	assert_response :success
 	end

 	 test "can see the new review creation form" do
 		get new_review_url
    	assert_response :success
 	end

 	test "can create a review" do
 		post reviews_url params: { :review => {:movie_id => "1235", :movie_title => "Little Man", :rating => 5, :comment => "Id dunno"}, :user => {:email => "blue@clues.com"} }
    	assert_response :found
 	end

 	test "cannot create a review without email" do
 		assert_raises(Exception) { post reviews_url params: { :review => {:movie_id => "1235", :movie_title => "Little Man", :rating => 5, :comment => "Id dunno"} }}
 	end

 	test "cannot create a review without movie id" do
 		assert_raises(Exception) { post reviews_url params: { :review => {:movie_title => "Little Man", :rating => 5, :comment => "Id dunno"}, :user => {:email => "blue@clues.com"}}}
 	end

 	test "cannot create a review without movie title" do
 		assert_raises(Exception) { post reviews_url params: { :review => {:movie_id => "1235", :rating => 5, :comment => "Id dunno"}, :user => {:email => "blue@clues.com"}}}
 	end

 	test "cannot create a review without rating" do
 		assert_raises(Exception) { post reviews_url params: { :review => {:movie_id => "1235", :movie_title => "Little Man", :comment => "Id dunno"}, :user => {:email => "blue@clues.com"}}}
 	end

 	test "can see a review" do
 		get review_url(:id => 1)
    	assert_response :success
 	end

 	test "can delete a review" do
 		delete review_url(:id => 1)
    	assert_response :found
 	end

 	test "cannot delete a review that doesn't exist" do
 		assert_raises(Exception) { delete review_url(:id => 315131) }
 	end
end
