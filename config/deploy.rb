# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'online_exam'
set :pty, true
set :repo_url, 'git@bitbucket.org:GopikaArun/online_exam.git'
set :scm, :git
set :user, "deployer"
set :use_sudo, true
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :deploy_via, :remote_cache
set :branch, 'master'

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.1.5'
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

  # after :restart, :clear_cache do
  #   on roles(:web), in: :groups, limit: 3, wait: 10 do
  #     # Here we can do anything such as:
  #     # within release_path do
  #     #   execute :rake, 'cache:clear'
  #     # end
  #   end
  # end

  # %w[start stop restart].each do |command|
  #   desc "#{command} unicorn server"
  #   task command do
  #     on roles(:app) do
  #       run "/etc/init.d/unicorn_#{fetch(:application)} #{command}"
  #     end
  #   end
  # end

  # task :setup_config do
  #   desc "==============#{fetch(:current_path)}/config/unicorn_init.sh"
  #   on roles(:app) do
  #     execute :sudo , "ln -nfs #{fetch(:current_path)}/config/nginx.conf /etc/nginx/sites-enabled/#{fetch(:application)}"
  #     execute :sudo , "ln -nfs #{fetch(:current_path)}/config/unicorn_init.sh /etc/init.d/unicorn_#{fetch(:application)}"
      
  #     #put File.read("config/database.example.yml"), "#{fetch(:shared_path)}/config/database.yml"
  #     puts "Now edit the config files in #{fetch(:shared_path)}."
  #   end
  # end
  # after :updating, "deploy:setup_config"

  # task :symlink_config do
  #   on roles(:app) do
  #     puts "excecuting"
  #     execute :sudo , "mkdir -p #{fetch(:shared_path)}/config"
  #     execute "ln -nfs #{fetch(:shared_path)}/config/database.yml #{fetch(:release_path)}/config/database.yml"
  #   end
  # end
  # before :updated, "deploy:symlink_config"
  desc 'Restart application'
    task :restart do
      on roles(:app), in: :sequence, wait: 5 do
         execute "sudo /etc/init.d/nginx restart"
     end
  end

end
