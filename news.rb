require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"

# configure the Dark Sky API with your API key
ForecastIO.api_key = "71da5cf09a52361268be1ca56cd56cf9"

# include News API
news_url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=968b9313d8624e01b75b1354c0b8858e"

def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }   


get "/" do
    view "form"
end

get "/news" do
  
    results = Geocoder.search(@params["q"])
    @lat_long = results.first.coordinates  # gives [lat, long]
    @forecast = ForecastIO.forecast("#{@lat_long[0]}", "#{@lat_long[1]}").to_hash
    @current_temperature = @forecast["currently"]["temperature"]
    @current_conditions = @forecast["currently"]["summary"]

    @news = HTTParty.get("https://newsapi.org/v2/top-headlines?country=us&apiKey=968b9313d8624e01b75b1354c0b8858e").parsed_response.to_hash
    

    #Now for the output
    #"
    #<p>Here is your input: #{params["q"]}</p>
    #<p>Here is the lat/long: #{@lat_long[0]}, #{@lat_long[1]}</p>
    #<p>In #{@params["q"]}, it is currently #{@current_temperature} degress, current conditions: #{@current_conditions}</p>
    #<p>Extended Forecast:</p>
    #"

    view "newspaper"
        #<% for @daily_forecast in @forecast["daily"]["data"] %>
        #    <p>A high temperature of #{@daily_forecast["temperatureHigh"]} and #{@daily_forecast["summary"]}</p>
        #<% end %>
    

    #"you typed #{params["q"]}"
end