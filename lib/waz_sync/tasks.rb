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

  desc "Sync your assets to Windows Azure, usage : rake waz:sync folders=images,stylesheets,javascripts (you can skip folders arg)"
  task :sync => :app_env do
    
    STDOUT.sync = true
    
    folders_tmp = ENV['folders']

    if folders_tmp.blank?
      folders = ["images", "javascripts", "stylesheets"]      
    else
      folders = folders_tmp.split(/,/)
    end
        
    azure = WazSync.new()
    
    folders.each{|folder|
      
      puts "  ==> Syncing #{folder}"
      
      container = azure.find_or_create_container(folder)    

      i = 0
      Dir.glob("#{Rails.root.to_s}/public/#{folder}/**/*").each do |file|
        i+=1
      end
            
      j = 0
      Dir.glob("#{Rails.root.to_s}/public/#{folder}/**/*").each do |file|
        if File.file?(file)              
          filename = file.gsub("/public/#{folder}/", "").gsub("#{Rails.root.to_s}", "")
          print "\r    ==> #{(((j.to_f/i.to_f)*10000).to_i / 100.0).ceil}%"          
          azure.send_or_update(container, file, filename)
        end
        j+=1
      end
      print "\n"
    }
    
    STDOUT.sync = false
  end
  
end