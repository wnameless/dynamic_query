class JoinedQueryController < ApplicationController
  def index
    dq = dynamic_query(Match::R201Cd2009, Match::R201Oo2009)
    @panel = dq.panel(params[:query])
    @records = Match::R201Cd2009.joins(
      multi_columns_join Match::R201Cd2009,
        [Match::R201Oo2009, :FEE_YM, :APPL_TYPE, :HOSP_ID, :APPL_DATE, :CASE_TYPE, :SEQ_NO]
      ).where(dq.statement(params[:query])).limit(5).all
  end
end
