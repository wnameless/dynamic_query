module DynamicQueryHelper
  def dynamic_query(panel, opt = {})
    html = ''
    yield html if block_given?
    template = ERB.new(File.read(File.dirname(__FILE__) + '/_dynamic_query.html.erb'))
    content = template.result(binding)
    content.html_safe
  end
  
  def dynamic_result(result)
    template = ERB.new(File.read(File.dirname(__FILE__) + '/_dynamic_result.html.erb'))
    content = template.result(binding)
    content.html_safe
  end
  
  def combined_result(result)
    template = ERB.new(File.read(File.dirname(__FILE__) + '/_combined_result.html.erb'))
    content = template.result(binding)
    content.html_safe
  end
end
