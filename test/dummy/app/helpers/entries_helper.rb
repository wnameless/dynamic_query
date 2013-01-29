# encoding: utf-8

module EntriesHelper
  
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == 'desc' ? 'asc' : 'desc'
    link_to title, list_entries_path(@list, :sort => column, :direction => direction), :class => css_class, :remote => true
  end
  
  def color_priority(priority)
    case priority
    when '3'
      '<label style="color: #FF0000;">●</label>'.html_safe
    when '2'
      '<label style="color: #0000FF;">●</label>'.html_safe
    else
      '<label style="color: #00FF00;">●</label>'.html_safe
    end
  end
  
end
