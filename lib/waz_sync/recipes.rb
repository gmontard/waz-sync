# Capistrano Recipes for managing waz_sync
#
# Add these callbacks to have the waz_sync process run
#
#   before "deploy:stop",    "waz_sync:sync"
#   before "deploy:start",   "waz_sync:sync"
#   before "deploy:restart", "waz_sync:sync"
#
# If you want to use command line options, for example to sync only images and stylesheets folders,
# define a Capistrano variable waz_sync_args:
#
#   set :waz_sync_args, "stylesheets,folders"
#

Capistrano::Configuration.instance.load do
  namespace :waz_sync do
    def rails_env
      fetch(:rails_env, false) ? "RAILS_ENV=#{fetch(:rails_env)}" : ''
    end

    def args
      fetch(:waz_sync_args, "")
    end

    desc "Sync your assets to Windows Azure"
    task :sync, :roles=> [:master] do
      run "cd #{current_path};#{rails_env} bundle exec rake waz:sync folders=#{args}"
    end
    
  end
end