require 'dynamic_query/validator'
require 'dynamic_query/joiner'

module DynamicQuery
  module CombineQuery
    include Validator, Joiner
    
    def conditions(query, table = nil)
      query ||= {}
      query = query.clone
      query = filter_valid_info(query)
      
      conditions = []
      query.each do |_, ands|
        conditions << ands.map { |_, v| condition_to_pair v }
      end
      
      cond = []
      conditions.each do |condition|
        c = {}
        condition.each do |pair|
          pair.each do |k, v|
            c[k] ||= []
            c[k].concat v
          end
        end
        c.keys.each { |k| c[k] = Hash[ c[k].each_slice(2).to_a ] }
        cond << c
      end 
      cond.map! { |c| c[table.to_s] } if table
      cond
    end
    
    def combine_query(query, relations)
      conds = conditions(query).first || {}
      models = relations.each_slice(3).map { |sec| sec.first }
      foreign_keys = relations - models
      
      selected_records = filter_conditioned_records(models, foreign_keys, conds)
      selected_records = remove_unlinked_records(selected_records, foreign_keys)
      join(selected_records, foreign_keys)
    end
    
    private
    def remove_unlinked_records(selected_records, foreign_keys)
      foreign_keys = foreign_keys.clone
      
      selected_records.each_with_index do |records, idx|
        unless foreign_keys.empty?
          delete_unlinked_records(records, foreign_keys.shift, selected_records[idx + 1], foreign_keys.shift)
        end
      end
      
      selected_records
    end
    
    def delete_unlinked_records(tgt, fks1, ref, fks2)
      ref_val = ref.map { |r| fks2.map { |fk| r.send(fk) } }
      tgt.keep_if { |t| ref_val.include?(fks1.map { |fk| t.send(fk) }) }
    end
    
    def filter_conditioned_records(models, foreign_keys, conds)
      foreign_keys = foreign_keys.clone
      
      selected_records = []
      determinate_values = nil
      models.each do |m|
        selected_records << m.where(conds[m.table_name]).all
        if determinate_values
          trim_records(selected_records.last, determinate_values, foreign_keys.shift)
        end
        if foreign_keys.empty?
          determinate_values = nil
        else
          fks = foreign_keys.shift
          determinate_values = selected_records.last.map { |r| fks.map { |fk| r.send(fk) } }
        end
      end
      selected_records
    end
    
    def trim_records(records, det_val, fks)
      records.keep_if { |r| det_val.include?(fks.map { |fk| r[fk] }) }
    end
    
    def condition_to_pair(cond)
      table, column = cond[:column].split(/\./)
      { table => ["#{column}.#{convert_op cond[:operator]}", convert_val(cond[:operator], cond[:value1], cond[:value2])] }
    end
    
    def convert_val(op, val1, val2)
      case op
      when 'IN', 'NOT IN'
        val1.split(/,/).delete_if { |word| word.blank? }.map { |word| word.strip }
      when 'BETWEEN', 'NOT BETWEEN'
        [val1, val2]
      when 'IS NULL', 'IS NOT NULL'
        nil
      else
        val1
      end
    end
    
    def convert_op(op)
      case op
      when '='
        'eq'
      when '>'
        'gt'
      when '>='
        'ge'
      when '<'
        'lt'
      when '<='
        'le'
      when '!='
        'not_eq'
      when 'LIKE'
        'like'
      when 'NOT LIKE'
        'not_like'
      when 'IN'
        'in'
      when 'NOT IN'
        'not_in'
      when 'BETWEEN'
        'btw'
      when 'NOT BETWEEN'
        'not_btw'
      when 'IS NULL'
        'is'
      when 'IS NOT NULL'
        'is_not'
      else
        'eq'
      end
    end
  end
end