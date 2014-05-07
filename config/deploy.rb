require 'recipiez/capistrano'
set :stages, %w(price_api production)
require 'capistrano/ext/multistage'
#require "bundler/capistrano"
set :normalize_asset_timestamps, false

