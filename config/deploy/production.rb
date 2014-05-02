require 'recipiez/capistrano'

set :application, "price_api"
set :repository,  ""
set :branch, "master"

default_run_options[:pty] = true


set :scm, :git
set :deploy_via, :remote_cache
set :user, 'deploy'
set :runner, user

set :node_env, "production"
set :rails_env, node_env
set :node_port, 3050

set :deploy_to, "/var/www/apps/#{application}"
set :app_domain, "customsmscs.veoo.com 54.216.82.205"

role :web, "customsmscs.veoo.com"                          # Your HTTP server, Apache/etc
role :app, "customsmscs.veoo.com"                          # This may be the same as your `Web` server
role :db,  "customsmscs.veoo.com", :primary => true # This is where Rails migrations will run



ssh_options[:keys] =  %w(/Users/rashthedude/.ssh/blissio ~/.ssh/mark)

namespace :deploy do
  task :start do
    sudo "start #{application}"
  end
  task :stop do
    begin
      sudo "stop #{application}"
    rescue
      # do nothing
    end
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end
end

after "deploy", "deploy:cleanup"
after "deploy:update_code", "npm:install"



set :bundle_dir, "#{shared_path}/bundle"
require "bundler/capistrano"




