class AddMovieTitleToReviews < ActiveRecord::Migration[5.2]
  def change
    add_column :reviews, :movie_title, :string
  end
end
