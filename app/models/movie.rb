class Movie < ActiveRecord::Base
    def self.ratings_avilable
        available_ratings = Array.new
        # Query for available ratings
        self.select("rating").uniq.each {|r| available_ratings.push(r.rating)}
        # Sort the unique ratings
        available_ratings.sort.uniq
    end
end
