uri = URI.parse(ENV["REDISTOGO_URL"])
Resque.redis = Redis.new(:host => uri.host,
                         :port => uri.port,
                         :password => uri.password)

Dir["#{Rails.root}/app/jobs/*.rb"].each { |file| require file }

require 'resque/server'
Resque::Server.class_eval do
  use Rack::Auth::Basic do |username, password|
    username == ENV['ADMIN']
    password == ENV['ADMIN_PASSWORD']
  end
end
