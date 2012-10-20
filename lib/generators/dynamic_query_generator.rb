require 'rails/generators'

class DynamicQueryGenerator < Rails::Generators::Base
  source_root File.expand_path("../../../", __FILE__)
  
  def manifest
    copy_file "app/assets/javascripts/dynamic_query.js", "app/assets/javascripts/dynamic_query.js"
  end
  
end