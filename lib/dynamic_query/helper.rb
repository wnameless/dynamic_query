module DynamicQuery
  module Helper
    def dynamic_query(panel, opt = {})
      template = ERB.new(File.read(File.dirname(__FILE__) + '/../../app/helpers/dynamic_query.erb'))
      content = template.result(binding)
      content.html_safe
    end
  end
end
