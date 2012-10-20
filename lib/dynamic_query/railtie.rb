require 'dynamic_query/helper'

module DynamicQuery
  
  class Railtie < Rails::Railtie
    
    initializer "dynamic_query" do
      ActionController::Base.send :include, DynamicQuery
    end
    
    initializer "dynamic_query.helper" do
      ActionView::Base.send :include, Helper
    end
    
  end
  
end
