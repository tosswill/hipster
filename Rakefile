$:.unshift(File.dirname(__FILE__))

require 'twitter'
require 'parse-ruby-client'

task :default => [:run]

 
load(File.open( 'keys.rb')) if File.exists?('keys.rb')

Parse.init :application_id => ENV['PARSE_APPLICATION_ID'] ,
           :api_key        => ENV['PARSE_API_KEY'] 


Twitter.configure do |config|
  config.consumer_key       = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret    = ENV['TWITTER_CONSUMER_SECRET']
  config.oauth_token        = ENV['OAUTH_TOKEN']     
  config.oauth_token_secret = ENV['OAUTH_TOKEN_SECRET'] 

end

desc "run app locally"
task :run => "Gemfile.lock" do
  require 'hipster'
  Sinatra::Application.run!
end

namespace :trends do
  
  task :pull do
    woid = 2487956 # code for SF
    capture_time = Time.now.to_i
    trend_string = ""

    terms = Twitter.trends(woid , {exclude: 'hashtags'})
    @debug = false

    def make_term( name, rank, time )
      o = Parse::Object.new("TopicTrend")
      o["topic"] = name
      o["time_string"] = "#{time}"
      o["ticks"] = 1
      o["high_rank"] = rank
      o.save unless @debug
    end

    rank = 1
    terms.each do |t|
      name = t.name.downcase
      existing = Parse::Query.new("TopicTrend").eq("topic", name ).get.first
      if existing
        puts "Existing term: #{name}"
        existing["time_string"] =  existing["time_string"] + " " + "#{capture_time}"
        existing["ticks"] = Parse::Increment.new(1)
        existing["high_rank"] = rank if existing["high_rank"].to_i < rank
        existing.save unless @debug
      else
        puts "New term: #{name}"
        make_term name, rank, capture_time
      end
      rank += 1
    end


    o = Parse::Object.new("TimeTrend")
    o["time"] = capture_time
    o["trend_string"] = terms.map(&:name).join(',').downcase
    o.save
  end

end