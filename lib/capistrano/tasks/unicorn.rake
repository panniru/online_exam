namespace :unicorn do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn"
    task command do
      on roles(:app) do
         execute "service unicorn_#{fetch(:application)} #{command}"
      end
    end 
    #after "deploy:#{command}", "unicorn:#{command}"
  end

  after "deploy:publishing", "unicorn:restart"
end
