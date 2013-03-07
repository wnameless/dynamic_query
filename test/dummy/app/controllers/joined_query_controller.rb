class JoinedQueryController < ApplicationController
  def index
    dq = dynamic_query Match::R201Cd2009, Match::R201Oo2009
    @panel = dq.panel(params[:query])
    @records = Match::R201Cd2009.
      select(all_columns_in Match::R201Cd2009, Match::R201Oo2009).
      joins(tables_joined_by Match::R201Cd2009,
        [Match::R201Oo2009, :FEE_YM, :APPL_TYPE, :HOSP_ID, :APPL_DATE, :CASE_TYPE, :SEQ_NO]).
      where(dq.statement params[:query]).
      paginate(:page => params[:page], :per_page => 20, :total_entries => Match::R201Oo2009.count)
  end
end
