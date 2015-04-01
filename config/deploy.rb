# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'online_exam'
set :pty, false
set :use_sudo, true
set :repo_url, 'git@github.com:sri-sankl/online_exam.git' #'git@bitbucket.org:GopikaArun/online_exam.git'
set :scm, :git
set :user, "deployer"
#set :ssh_options , { :forward_agent => true }

set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :current_path, "#{fetch(:deploy_to)}/current"
set :shared_path, "#{fetch(:deploy_to)}/shared"
set :deploy_via, :remote_cache
set :branch, 'master'

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.0.0-p598'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value


# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml} 

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')


# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc "Link Nginx and unicorn services"
  task :link_services do
    on roles(:app) do
      execute :sudo ,"ln -nfs #{fetch(:current_path)}/config/nginx.conf /etc/nginx/sites-enabled/#{fetch(:application)}"
      execute :sudo, "ln -nfs #{fetch(:current_path)}/config/unicorn_init.sh /etc/init.d/unicorn_#{fetch(:application)}"
    end
  end

  before :publishing, "deploy:link_services"

  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:web) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

end
