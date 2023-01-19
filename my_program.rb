p "Where are you located?"

user_location = gets.chomp
p user_location
p "Checking the weather at " + user_location
gmapskey = ENV.fetch("GMAPS_KEY")

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{gmapskey}"

require("open-uri")
require("json")

raw_response = URI.open(gmaps_url).read

parsed_gmaps = JSON.parse(raw_response)

results_array = parsed_gmaps.fetch("results")

only_result = results_array.at(0)

geo = only_result.fetch("geometry")

loc = geo.fetch("location")

lat = loc.fetch("lat")

long = loc.fetch("lng")

dark_sky_key = ENV.fetch("DARK_SKY_KEY")

dark_sky_url = "https://api.darksky.net/forecast/#{dark_sky_key}/#{lat},#{long}"

darksky_raw = URI.open(dark_sky_url).read

parsed_dark_sky = JSON.parse(darksky_raw)

currently = parsed_dark_sky.fetch("currently")

temp = currently.fetch("temperature")

p "It is currently " + temp.to_s + "°F"

summary = currently.fetch("summary")

p "Next hour: " + summary

hourly = parsed_dark_sky.fetch("hourly")

hourly_array = hourly.fetch("data")

i = 0
rain_counter = 0

hourly_array.each do |hours|
  if i > 0 && i <= 12
    probability = hours.fetch("precipProbability")
    if probability > 0
      p "In " + i.to_s + " hours, there is a " + (probability*100).to_s  + "% chance of precipitation." 
    end
      i = i+1
      if probability > 0.1
        rain_counter = rain_counter + 1
      end
  elsif i == 0
    i = 1
  else
  end
end

if rain_counter == 0 
  p "You probably won't need an umbrella today."
else
  p "You might want to carry an umbrella!"
end
