class CreateRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :ratings do |t|
      t.integer :movie_id
      t.integer :one_star
      t.integer :two_star
      t.integer :three_star
      t.integer :four_star
      t.integer :five_star
      t.float :avg

      t.timestamps
    end
  end
end
