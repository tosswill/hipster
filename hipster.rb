require 'sinatra'
require 'active_support/all'
require 'parse-ruby-client'

Parse.init :application_id => ENV['PARSE_APPLICATION_ID'] ,
           :api_key        => ENV['PARSE_API_KEY'] 

get '/' do
  "Hipster API: Before it was cool."
end

get '/trends' do
  start_time = params["start_time"]
  end_time =  params["end_time"]
  min_rank =  (params["min_rank"]|| 3)
  
  vals = Parse::Query.new("TopicTrend").tap do |q|
    q.less_eq("high_rank", min_rank.to_i)
    if start_time && end_time
      q.greater_eq("updatedAt",Parse::Date.new(start_time))
      q.less_eq("updatedAt",Parse::Date.new(end_time))
    else
      q.greater_eq("updatedAt",Parse::Date.new(Date.today.to_s))
    end
  end.get
  vals.to_json
end

get '/random' do
  count = params["count"].nil? ? 500 : params["count"].to_i
  start_time = params["start_time"]
  end_time =  params["end_time"]
  min_rank =  (params["min_rank"]|| 3)
  
  
  vals = Parse::Query.new("TopicTrend").tap do |q|
    q.less_eq("high_rank", min_rank.to_i)
    if start_time && end_time
      q.greater_eq("updatedAt",Parse::Date.new(start_time))
      q.less_eq("updatedAt",Parse::Date.new(end_time))
    else
      q.greater_eq("updatedAt",Parse::Date.new(Date.today.to_s))
    end
  end.get
  vals = vals.sample(count)
  vals.to_json
end
