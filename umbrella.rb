# Write your solution below!
gem install dotenv

require "http"
require "json"
require "dotenv/load"

pirate_weather_api_key = ENV.fetch("PIRATE_WEATHER_KEY")
