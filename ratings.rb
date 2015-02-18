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

def self.errors?(movie)
  false
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
read_file_from("movies.csv").each do |movie|
  if OMDbApi.errors?(movie)
    puts "something went wrong"
  else movie["rating"] = OMDbApi.movie_rating(movie)
    movies_with_ratings << movie
  end
end

movies_with_ratings.each do |movie|
  puts "Title: #{movie["title"]} Year: #{movie["rating"]}"
end
