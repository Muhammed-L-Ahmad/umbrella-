# Write your solution below!

require "http"
require "json"
require "dotenv/load"

pirate_weather_api_key = ENV.fetch("PIRATE_WEATHER_KEY")
gmaps_api_key = ENV.fetch("GMAPS_KEY")
# Ask the user for their location. (Recall gets.)
pp "Hello, welcome to the Umbrella weather app.  What is your current location?"
# Get and store the user’s location.
 location = gets.chomp
# Get the user’s latitude and longitude from the Google Maps API.
# Step 2: Get coordinates from Google Maps Geocoding API
encoded_location = URI.encode_www_form_component(location)
gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{encoded_location}&key=#{gmaps_api_key}"

gmaps_response = HTTP.get(gmaps_url)
gmaps_data = JSON.parse(gmaps_response)

if gmaps_data["status"] != "OK"
  puts "❌ Sorry, we couldn't find that location"
  exit
end
# Get the user’s latitude and longitude from the Google Maps API.
coordinates = gmaps_data["results"][0]["geometry"]["location"]
latitude = coordinates["lat"]
longitude = coordinates["lng"]

pp "📌 Your coordinates are: #{latitude}, #{longitude}"
# Get the weather at the user’s coordinates from the Pirate Weather API.
pirate_url = "https://api.pirateweather.net/forecast/#{pirate_weather_api_key}/#{latitude},#{longitude}"

weather_response = HTTP.get(pirate_url)
weather_data = JSON.parse(weather_response)
# Display the current temperature and summary of the weather for the next hour.
# If you get that far, then stretch further:
current_temp = weather_data["currently"]["temperature"]
hourly_summary = weather_data["hourly"]["summary"]

pp "🌡️ It is currently #{current_temp} °F."
pp "📅 Forecast for the next hour: #{hourly_summary}"
# For each of the next twelve hours, check if the precipitation probability is greater than 10%.
rain_hours = []
weather_data = ["hourly"]["data"][0..11].each_with_index do |hour_data, i|
  precip_prob = hour_data["precipProbabiliy"]
  if precip_prob > 0.1
    rain_hours << { hour: i, probability: precip_prob }
# If so, print a message saying how many hours from now and what the precipitation probability is.
    puts "⏱️ In #{i} hours, there is a #{(precip_prob * 100).round}% chance of precipitation."
  end
end
# If any of the next twelve hours has a precipitation probability greater than 10%, print “You might want to carry an umbrella!”
if rain_hours.any?
  puts "☔ You might want to carry an umbrella!"
# If not, print “You probably won’t need an umbrella today.”
else
  puts "😎 You probably won't need an umbrella today."
end
