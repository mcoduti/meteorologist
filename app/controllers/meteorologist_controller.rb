require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]
    url_safe_street_address = URI.encode(@street_address)

    # ==========================================================================
    # Your code goes below.
    # The street address the user input is in the string @street_address.
    # A URL-safe version of the street address, with spaces and other illegal
    #   characters removed, is in the string url_safe_street_address.
    # ==========================================================================
    api_url = "http://maps.googleapis.com/maps/api/geocode/json?address=" + @street_address.gsub(" ","+")
    raw_data = open(api_url).read
    parsed_data =JSON.parse(raw_data)
    results = parsed_data["results"]
    first = results[0]
    geometry = first["geometry"]
    location = geometry["location"]
    lat = location["lat"]
    lng = location["lng"]

    api_url2 = "https://api.forecast.io/forecast/1d66f77c6c2c133935cf6de9f659a2cf/" +lat.to_s + "," + lng.to_s
    raw_data2 = open(api_url2).read
    parsed_data2 =JSON.parse(raw_data2)


    @current_temperature = parsed_data2["currently"]["temperature"]

    @current_summary = parsed_data2["currently"]["summary"]

    @summary_of_next_sixty_minutes =  parsed_data2["minutely"]["summary"]

    @summary_of_next_several_hours = parsed_data2["hourly"]["summary"]

    @summary_of_next_several_days = parsed_data2["daily"]["summary"]

    render("street_to_weather.html.erb")
  end
end
