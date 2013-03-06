class JoinedQueryController < ApplicationController
  def index
    dq = dynamic_query(Match::R201Cd2009, Match::R201Oo2009)
    @panel = dq.panel(params[:query])
    @records = Match::R201Cd2009.joins(
      multi_columns_join Match::R201Cd2009,
        [Match::R201Oo2009, :FEE_YM, :APPL_TYPE, :HOSP_ID, :APPL_DATE, :CASE_TYPE, :SEQ_NO]
      ).where(dq.statement(params[:query])).limit(5).all
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
end
