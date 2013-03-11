require 'rails/generators'

module DynamicQuery
  class HelperGenerator < Rails::Generators::Base
    source_root File.expand_path('../../../', __FILE__)
  
    def manifest
      copy_file 'app/helpers/dynamic_query_helper.rb', 'app/helpers/dynamic_query_helper.rb'
      copy_file 'app/helpers/_dynamic_query.html.erb', 'app/helpers/_dynamic_query.html.erb'
      copy_file 'app/helpers/_dynamic_result.html.erb', 'app/helpers/_dynamic_result.html.erb'
      #copy_file 'app/helpers/_combined_result.html.erb', 'app/helpers/_combined_result.html.erb'
    end
  end
end