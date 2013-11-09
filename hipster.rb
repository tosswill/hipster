require 'sinatra'
require 'active_support/all'
require 'parse-ruby-client'

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