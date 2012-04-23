namespace :waz do
  task :app_env do
    if defined?(RAILS_ROOT)
      Rake::Task[:environment].invoke
      if defined?(Rails.configuration)
        Rails.configuration.cache_classes = false
      else
        Rails::Initializer.run { |config| config.cache_classes = false }
      end
    elsif defined?(Merb)
      Rake::Task[:merb_env].invoke
    elsif defined?(Sinatra)
      Sinatra::Application.environment = ENV['RACK_ENV']
    end
  end

  desc "Sync your assets to Windows Azure, usage : rake waz_sync:sync folders=images,stylesheets,javascripts (you can skip folders arg)"
  task :sync => :app_env do
    
    folders = ENV['folders'].split(/,/)

    if folders.blank?
      folders = ["images", "javascripts", "stylesheets"]      
    end
        
    azure = WazSync.new()
    folders.each{|folder|

      container = azure.find_or_create_container(folder)    

      Dir.glob("#{Rails.root.to_s}/public/#{folder}/**/*").each do |file|
        if File.file?(file)              
          filename = file.gsub("/public/#{folder}/", "").gsub("#{Rails.root.to_s}", "")
          p filename
          azure.send_or_update(container, file, filename)
        end
      end
    }
  end
  
end