require "rvm/capistrano"
require "bundler/capistrano"

set :application, "social_drink"
set :repository,  "git@github.com:railsrumble/r12-team-164.git"

set :user, "root"

set :scm, :git
set :git_shallow_clone, 1

set :deploy_to, "/home/social_drink"
set :deploy_via, :copy
set :keep_releases, 2
set :use_sudo, false

role :web, "198.74.58.174"                          # Your HTTP server, Apache/etc
role :app, "198.74.58.174"                          # This may be the same as your `Web` server
role :db,  "198.74.58.174", :primary => true # This is where Rails migrations will run
role :db,  "198.74.58.174"

set :rvm_ruby_string, '1.9.3'
set :rvm_type, :system

after "deploy:restart", "deploy:cleanup"


namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end