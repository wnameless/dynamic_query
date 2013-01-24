require 'rails/generators'

module DynamicQuery
  class HelperGenerator < Rails::Generators::Base
    source_root File.expand_path('../../../', __FILE__)
  
    def manifest
      copy_file 'app/helpers/dynamic_query_helper.rb', 'app/helpers/dynamic_query_helper.rb'
      copy_file 'app/helpers/dynamic_query.erb', 'app/helpers/dynamic_query.erb'
    end
  end
end