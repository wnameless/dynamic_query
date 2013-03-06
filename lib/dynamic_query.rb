require 'dynamic_query/railtie' if defined?(Rails)
require 'generators/helper_generator' if defined?(Rails)
require 'dynamic_query/combined_query'
require 'dynamic_query/validator'
require 'arel'

module DynamicQuery
  OPERATOR = ['=', '>', '>=', '<', '<=', '!=',
              'LIKE', 'NOT LIKE', 'IN', 'NOT IN',
              'BETWEEN', 'NOT BETWEEN', 'IS NULL', 'IS NOT NULL']
              
  def dynamic_query(*models, opt)
    DynamicQueryInstance.new(*models, opt)
  end
  
  def multi_columns_join(from, *to_tables)
    f = Arel::Table.new from.table_name
    alias_counter = {}
    table_aliases = {}
    to_tables.each do |tt|
      to_table_name = tt.first.table_name
      t = Arel::Table.new to_table_name
      table_aliases[to_table_name] ||= []
      tt.drop(1).each do |mapping|
        if alias_counter[to_table_name].nil?
          alias_counter[to_table_name] = 0
          table_aliases[to_table_name] << t
        end
        alias_counter[to_table_name] += 1
        table_aliases[to_table_name] << Arel::Table.new(to_table_name, :as => "#{to_table_name}_#{alias_counter[to_table_name]}")
      end
    end
    
    query = f.clone
    to_tables.each do |tt|
      to_table_name = tt.first.table_name
      tt.drop(1).each do |mapping|
        target = table_aliases[to_table_name].shift
        if mapping.kind_of? Array
          query = query.join(target).on( f[mapping.first].eq target[mapping.last] )
        else
          query = query.join(target).on( f[mapping].eq target[mapping] )
        end
      end
    end
    
    sql = query.project(Arel.sql('*')).to_sql
    sql[sql.index('INNER JOIN')..-1]
  end
              
  class DynamicQueryInstance
    include CombinedQuery, Validator
    
    def initialize(*models, opt)
      @reveal_keys = false
      @white_list = []
      @black_list = []
      @aliases = {}
      
      if opt.kind_of? Array
        models = models + opt
        opt = {}
      end
      
      unless opt.kind_of? Hash
        models << opt
        opt = {}
      end
      
      models.map! do |m|
        if [String, Symbol].include? m.class
          m.to_s.split(/_/).map { |word| word.capitalize }.join.constantize
        else
          m
        end       
      end
      
      opt.each do |key, val|
        @reveal_keys = true if key == :reveal_keys && val
        
        if key == :accept
          val.each do |model, columns|
            if models.include? model
              # model = model.to_s.split(/_/).map { |word| word.capitalize }.join.constantize
              columns.each { |col|  @white_list << "#{model.table_name}.#{col}" }
            end
          end
        end
        
        if key == :reject
          val.each do |model, columns|
            if models.include? model
              # model = model.to_s.split(/_/).map { |word| word.capitalize }.join.constantize
              columns.each { |col|  @black_list << "#{model.table_name}.#{col}" }
            end
          end
        end
        
        if key == :alias
          @aliases = val.kind_of?(Hash) ? val.clone : {}
        end
      end if opt.kind_of? Hash
      
      @columns = {}
      models.each do |model|
        # model = model.to_s.split(/_/).map { |word| word.capitalize }.join.constantize
        model = Hash[model.columns.map { |col| ["#{model.table_name}.#{col.name}"] * 2 }]
        @columns.merge! model
      end
      
      @column_types = {}
      models.each do |model|
        # model = model.to_s.split(/_/).map { |word| word.capitalize }.join.constantize
        model = Hash[model.columns.map { |col| ["#{model.table_name}.#{col.name}", col.type] }]
        @column_types.merge! model
      end
      
      unless @reveal_keys
        @columns.keys.each do |key|
          @columns.delete key if key =~ /\.id$/ || key =~ /_id$/
        end
      end
      
      unless @white_list.empty?
        selected_columns = {}
        @white_list.each do |white|
          selected_columns[white] = @columns[white] if @columns.keys.include? white
        end
        @columns = selected_columns
      end
      
      @black_list.each { |black| @columns.delete black }
      
      translate_columns = {}
      used_aliases = {}
      @columns.each do |option, value|
        if @aliases[option]
          used_aliases[option] = @aliases[option]
          translate_columns[@aliases[option]] = value
        else
          translate_columns[option] = value
        end
      end
      @columns = translate_columns
      @aliases = used_aliases
    end
    
    def panel(query)
      query ||= { 'or_1' => { 'and_1' => { :column => '', :operator => '', :value1 => '', :value2 => '' } } }
      query = query.clone
      action = query[:action]
      
      panel = filter_valid_info(query)
      panel_action(panel, action)
      panel[:columns] = @columns.clone
      
      panel
    end
    
    def statement(query)
      query ||= { 'or_1' => { 'and_1' => { :column => '', :operator => '', :value1 => '', :value2 => '' } } }
      query = query.clone
      query = filter_valid_info(query)
      
      or_stat = []
      query.each do |or_key, or_val|
        and_stat = [[]]
        or_val.each do |and_key, and_val|
          if @columns.include?(and_val[:column]) || @aliases.include?(and_val[:column])
            case and_val[:operator]
            when '=', '>', '>=', '<', '<=', '!=', 'LIKE', 'NOT LIKE'
              unless and_val[:value1].blank?
                and_stat[0] << "#{and_val[:column]} #{and_val[:operator]} ?"
                and_stat << and_val[:value1]
              end
            when 'IN', 'NOT IN'
              unless and_val[:value1].delete(',').blank?
                and_stat[0] << "#{and_val[:column]} #{and_val[:operator]} (?)"
                and_stat << and_val[:value1].split(/,/).delete_if { |word| word.blank? }.map { |word| word.strip }
              end
            when 'BETWEEN', 'NOT BETWEEN'
              unless and_val[:value1].blank? || and_val[:value2].blank?
                and_stat[0] << "#{and_val[:column]} #{and_val[:operator]} ? AND ?"
                and_stat << and_val[:value1] << and_val[:value2]
              end
            when 'IS NULL', 'IS NOT NULL'
              and_stat[0] << "#{and_val[:column]} #{and_val[:operator]}"
            end
          end
        end
              
        and_stat[0] = and_stat[0].join(' AND ')
        or_stat << and_stat unless and_stat[0].empty?
      end
        
      or_stat.each { |and_stat| and_stat[0] = "(#{and_stat[0]})" }
      stat = []; params = []
      or_stat.each do |and_stat|
        stat << and_stat.shift
        params = params + and_stat
      end
      params.unshift(stat.join(' OR '))
    end
    
    private
    def panel_action(panel, action)
      case action.keys.first
      when /^add_or$/
        or_key = get_new_or_condition_key(panel)
        panel[or_key] = { 'and_1' => { :column => '', :operator => '', :value1 => '', :value2 => '' } }
      when /^remove_or_\d+$/
        panel.delete("or_#{action.keys.first.match(/\d+/)[0]}")
      when /^add_and_to_or_\d+$/
        or_key = "or_#{action.keys.first.match(/\d+/)[0]}"
        and_key = get_new_and_condition_key(panel[or_key])
        panel[or_key][and_key] = { :column => '', :operator => '', :value1 => '', :value2 => '' }  
      when /^remove_and_\d+_from_or_\d+$/
        or_key = "or_#{action.keys.first.scan(/\d+/)[1]}"
        and_key = "and_#{action.keys.first.scan(/\d+/)[0]}"
        panel[or_key].delete(and_key) if panel[or_key]
      end if action.kind_of?(Hash)
    end
    
    def get_new_or_condition_key(or_conditions)
      count = or_conditions.keys.map { |key| key.match(/\d+/)[0].to_i }.max.to_i + 1
      "or_#{count}"
    end
    
    def get_new_and_condition_key(and_conditions)
      count = and_conditions.keys.map { |key| key.match(/\d+/)[0].to_i }.max.to_i + 1
      "and_#{count}"
    end
  end
end
