class Movie < ActiveRecord::Base

  def self.all_ratings
    a = Array.new
    self.select("rating").uniq.each {|e| a.push(e.rating)}
    a.sort.uniq
    #b = Array new
    #puts self.select_values("SELECT DISTINCT rating FROM movies")
  end

  def self.init
    true
  end

end 


