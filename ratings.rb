require 'json'
require 'net/http'
require 'open-uri'
require 'pry'
require "csv"

class OMDbApi

 def self.connect_api
  query = ""
  @result = JSON.parse(Net::HTTP.get(URI.parse(URI.escape(query))))
end

def errors?

end

def movie_rating

end
end

def read_file_from(filename)
  movies = []

  CSV.foreach(filename, headers: true) do |row|
    movies << row.to_hash
  end
  movies
end

puts read_file_from("movies.csv")
