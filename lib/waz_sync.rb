class WazSync
    
  require 'waz-blobs'
  
  def initialize
    yaml_azure = YAML::load(ERB.new(File.read(Rails.root.to_s + '/config/azure.yml')).result).stringify_keys[Rails.env]
    WAZ::Storage::Base.establish_connection!(:account_name => yaml_azure["account_name"], :access_key => yaml_azure["access_key"])    
  end
  
  def find_or_create_container(container)
    if WAZ::Blobs::Container.find(container).nil? 
      container = WAZ::Blobs::Container.create(container)
      container.public_access = "blob"
    else
      container = WAZ::Blobs::Container.find(container)
    end
    return(container)
  end
  
  def send_or_update(container, file, filename, options = {:x_ms_blob_cache_control=>"max-age=315360000, public"})
    obj = container[filename] rescue nil
    if !obj || (obj.railsetag != Digest::MD5.hexdigest(File.read(file)))
      Rails.logger.info("Create / Updating : #{filename}")
      content_type = MIME::Types.type_for(file).to_s.blank? ? "text/plain" : MIME::Types.type_for(file).to_s
      container.store(filename, File.read(file), content_type, options) rescue 'error'   
    end
  end
  
end