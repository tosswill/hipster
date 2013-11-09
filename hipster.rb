require 'sinatra'
require 'active_support/all'
require 'parse-ruby-client'

Parse.init :application_id => ENV['PARSE_APPLICATION_ID'] ,
           :api_key        => ENV['PARSE_API_KEY'] 


Twitter.configure do |config|
  config.consumer_key       = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret    = ENV['TWITTER_CONSUMER_SECRET']
  config.oauth_token        = ENV['OAUTH_TOKEN']     
  config.oauth_token_secret = ENV['OAUTH_TOKEN_SECRET'] 

get '/' do
  "Hello World!"
end

get '/trends' do
  vals = Parse::Query.new("TopicTrend").tap do |q|
    q.less_eq("high_rank", 3)
    q.greater_eq("updatedAt",Parse::Date.new(Date.today.to_s))
  end.get
  vals.to_json
end