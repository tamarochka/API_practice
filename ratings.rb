require 'json'
require 'net/http'
require 'open-uri'
require 'pry'
require "csv"

class OMDbApi

 def self.connect_api(movie)
  query = "http://www.omdbapi.com/?t=#{movie["title"]}&y=#{movie["year"]}&plot=short&r=json"
  result = JSON.parse(Net::HTTP.get(URI.parse(URI.escape(query))))
end

def self.no_errors?(movie)
  result = connect_api(movie)
  result["response"] != "error"
end

def self.movie_rating(movie)
  movie = connect_api(movie)
  movie["imdbRating"]
end

end

def read_file_from(filename)
  movies = []
  CSV.foreach(filename, headers: true) do |row|
    movies << row.to_hash
  end
  movies
end

movies_with_ratings = []

SLEEP_WINDOW = 60 * 1 # minutes
read_file_from("movies.csv").each_slice(10) do |chunk| #slicing an array to limit 10requests at a time
  start_time = Time.now
  chunk.each do |movie|
    if OMDbApi.no_errors?(movie)
      movie["rating"] = OMDbApi.movie_rating(movie).to_f
    else
      movie["rating"]= 0
    end
    movies_with_ratings << movie
  end
  sleep_time = SLEEP_WINDOW - (Time.now - start_time)
  sleep sleep_time if (sleep_time > 0)
end

movies_with_ratings.sort_by{|k| k["rating"]}.each do |movie|
  puts "Title: #{movie["title"]} Rating: #{movie["rating"]}"
end
