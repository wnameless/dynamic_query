module ApplicationHelper
  def show_errors(record)
    errors = ''
    
    if record.errors.any?
      errors << '<div id="error_explanation"><h2>' <<
      pluralize(record.errors.count, "error") <<
      'prohibited this entry from being saved:</h2><ul>'
      
      record.errors.full_messages.each do |msg|
        errors << "<li>#{msg}</li>"
      end
      
      errors << '</ul></div>'
    end
    
    errors.html_safe
  end
end
