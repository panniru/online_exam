desc "reload the database with seed data"
namespace :seeds do
  task :seed do
       on roles(:app) do     
       execute "cd #{current_path}; RAILS_ENV=#{fetch(:rails_env)} #{fetch(:rbenv_prefix)} bundle exec rake db:seed"
       end
  end  
end    
