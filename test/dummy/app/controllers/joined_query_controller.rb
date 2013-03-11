class JoinedQueryController < ApplicationController
  def index
    dq = dynamic_query Match::R201Cd2009, Match::R201Oo2009
    @panel = dq.panel(params[:query])
    
    conditioned_model = Match::R201Cd2009.
      select(all_columns_in Match::R201Cd2009, Match::R201Oo2009).
      joins(tables_joined_by Match::R201Cd2009,
        [Match::R201Oo2009, :FEE_YM, :APPL_TYPE, :HOSP_ID, :APPL_DATE, :CASE_TYPE, :SEQ_NO]).
      where(dq.statement params[:query])
    
    total = estimate_total(dq, params[:query])
    if total <= 1000
      total = conditioned_model.count
    end
    
    @records = conditioned_model.paginate(:page => params[:page], :per_page => 20, :total_entries => total)
      #@conditions = dq.conditions params[:query], :r201_cd2009
      #@conditions2 = dq.conditions params[:query], :r201_oo2009
      #@statement = Querier.statement @conditions
      #@statement2 = Querier.statement @conditions2
      #@count = Match::R201Cd2009.where(@statement).count
      #@count2 = Match::R201Oo2009.where(@statement2).count
      #@et = estimate_total dq, params[:query]
  end
end
