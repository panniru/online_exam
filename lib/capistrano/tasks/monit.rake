namespace :monit do
  desc "Install Monit"
  task :install do
       on roles(:all) do
          execute :sudo, "apt-get -y install monit"
       end 
  end
  #after 'deploy:setup_config', "monit:install"

  desc "Setup all Monit configuration"
  task :setup do
    on roles(:all) do     
       monit_config "monitrc", "/etc/monit/monitrc"
       monit_config "nginx" 
       monit_config "postgresql"
       monit_config "unicorn"
       #monit_config "delayed_job"    
       execute :sudo, "service monit syntax"  
       execute :sudo, "service monit reload"  
       #monit:nginx
       #postgresql
       #unicorn
       #syntax
       #reload
    end
  end
  #after 'deploy:setup_config', "monit:setup"
  
  desc "nginx monit"
  task :nginx do 
    on roles(:web) do 
     monit_config "nginx" 
   end 
  end

  desc "postgres monit"
  task :postgresql do 
    on roles(:db) do 
     monit_config "postgresql" 
    end 
  end
  
  desc "unicorn monit"
  task :unicorn do 
    on roles(:app) do 
     monit_config "unicorn" 
    end 
  end

  %w[start stop restart syntax reload].each do |command|
    desc "Run Monit #{command} script"
    task command do
      execute :sudo, "service monit #{command}"
    end
  end
end

def monit_config(name, destination = nil)
  destination ||= "/etc/monit/conf.d/#{name}.conf"
  template "monit/#{name}.erb", "/tmp/monit_#{name}"
  execute :sudo, "mv /tmp/monit_#{name} #{destination}"
  execute :sudo, "chown root #{destination}"
  execute :sudo, "chmod 600 #{destination}"
end

def template(from, to)
  erb = File.read(File.expand_path("../../templates/#{from}", __FILE__))
  upload! StringIO.new(ERB.new(erb).result(binding)), to
  #execute :sudo, :chmod, "644 #{to}"
end

