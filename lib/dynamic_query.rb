require 'dynamic_query/railtie' if defined?(Rails)

module DynamicQuery
  OPERATOR = ['=', '>', '>=', '<', '<=', '!=',
              'LIKE', 'NOT LIKE', 'IN', 'NOT IN',
              'BETWEEN', 'NOT BETWEEN', 'IS NULL', 'IS NOT NULL']
              
  def dynamic_query(*models, opt)
    DynamicQueryInstance.new(*models, opt)
  end
              
  class DynamicQueryInstance
    
    def initialize(*models, opt)
      @reveal_keys = false
      @white_list = []
      @black_list = []
      
      if opt.kind_of?(Array)
        models = models + opt
        opt = {}
      end
      
      unless opt.kind_of?(Hash)
        models << opt
        opt = {}
      end
      
      opt.each do |key, val|
        @reveal_keys = true if key == :reveal_keys && val
        
        if key == :accept
          val.each do |model, columns|
            if models.include?(model)
              model = model.to_s.split(/_/).map { |word| word.capitalize }.join.constantize
              columns.each { |col|  @white_list << "#{model.table_name}.#{col}" }
            end
          end
        end
        
        if key == :reject
          val.each do |model, columns|
            if models.include?(model)
              model = model.to_s.split(/_/).map { |word| word.capitalize }.join.constantize
              columns.each { |col|  @black_list << "#{model.table_name}.#{col}" }
            end
          end
        end
      end if opt.kind_of?(Hash)
      
      @columns = {}
      models.each do |model|
        model = model.to_s.split(/_/).map { |word| word.capitalize }.join.constantize
        model = model.columns.map { |col| { "#{model.table_name}.#{col.name}" => col.type } }.reduce(:merge)
        @columns.merge!(model)
      end
      
      unless @reveal_keys
        @columns.keys.each do |key|
          @columns.delete(key) if key =~ /.id$/ || key =~ /_id$/
        end
      end
      
      unless @white_list.empty?
        selected_columns = {}
        @white_list.each do |white|
          selected_columns[white] = @columns[white] if @columns.keys.include?(white)
        end
        @columns = selected_columns
      end
      
      @black_list.each { |black| @columns.delete(black) }
    end
    
    def panel(query)
      query ||= { 'or_1' => { 'and_1' => { :column => '', :operator => '', :value1 => '', :value2 => '' } } }
      add_and_condition(query)
      add_or_condition(query)
      remove_and_condition(query)
      remove_or_condition(query)
      query[:columns] = @columns
      query
    end
    
    def statement(query)
      query ||= { 'or_1' => { 'and_1' => { :column => '', :operator => '', :value1 => '', :value2 => '' } } }
      or_stat = []
      query.select { |k, _| k =~ /^or_\d+$/ }.each do |or_key, or_val|
        and_stat = []
        or_val.each do |and_key, and_val|
          case and_val[:operator]
          when '=', '>', '>=', '<', '<=', '!=', 'LIKE', 'NOT LIKE'
            and_stat << "#{and_val[:column]} #{and_val[:operator]} '#{and_val[:value1]}'" unless and_val[:value1].blank?
          when 'IN', 'NOT IN'
            and_stat << "#{and_val[:column]} #{and_val[:operator]} (#{and_val[:value1].split(/,/).select { |word| !word.strip.empty? }.map { |word| "'" + word.strip + "'" }.join(',')})" unless and_val[:value1].delete(',').blank?
          when 'BETWEEN', 'NOT BETWEEN'
            and_stat << "#{and_val[:column]} #{and_val[:operator]} '#{and_val[:value1]}' AND '#{and_val[:value2]}'" unless and_val[:value1].blank? || and_val[:value2].blank?
          when 'IS NULL', 'IS NOT NULL'
            and_stat << "#{and_val[:column]} #{and_val[:operator]}"
          end
        end
        
        and_stat_str = and_stat.join(' AND ')
        or_stat << "(#{and_stat_str})" unless and_stat_str.empty?
      end
      
      or_stat = or_stat.join(' OR ')
    end
    
    
    private
    
    
    def remove_or_condition(query)
      query.each do |key, val|
        if key =~ /^remove_or_\d+$/
          query.delete("or_#{key.match(/\d+/)[0]}")
          break
        end
      end
    end
    
    def remove_and_condition(query)
      query.each do |key, val|
        if key =~ /^or_\d+-and_\d+$/
          query["or_#{key.scan(/\d+/)[0]}"].delete("and_#{key.scan(/\d+/)[1]}")
          break
        end
      end
    end
    
    def add_or_condition(query)
      or_key = nil
      
      query.each do |key, val|
        if key =~ /^add_or$/
          or_key = get_new_or_condition_key(query)
          break
        end
      end
      
      if or_key
        query[or_key] = {}
        query[or_key]['and_1'] = { :column => '', :operator => '', :value1 => '', :value2 => '' }
      end
    end
    
    
    def add_and_condition(query)
      query.each do |key, val|
        if key =~ /^or_\d+-and$/
          and_key = get_new_and_condition_key(query["or_#{key.match(/\d+/)[0]}"])
          query["or_#{key.match(/\d+/)[0]}"][and_key] = { :column => '', :operator => '', :value1 => '', :value2 => '' }
          break
        end
      end
    end
    
    def get_new_or_condition_key(query)
      count = query.keys.select { |i| i =~ /\d+$/ }.map { |key| key.match(/\d+/)[0].to_i }.max.to_i + 1
      p count
      "or_#{count}"
    end
    
    def get_new_and_condition_key(or_condition)
      count = or_condition.keys.map { |key| key.match(/\d+/)[0].to_i }.max.to_i + 1
      "and_#{count}"
    end
  
  end
  
end
