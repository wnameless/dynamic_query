class JoinedQueryController < ApplicationController
  def index
    dq = dynamic_query(Match::R201Cd2009, Match::R201Oo2009)
    @panel = dq.panel(params[:query])
    @records = Match::R201Cd2009.
      select(all_columns_in Match::R201Cd2009, Match::R201Oo2009).
      joins(joined_by_columns Match::R201Cd2009, [Match::R201Oo2009, :FEE_YM, :APPL_TYPE, :HOSP_ID, :APPL_DATE, :CASE_TYPE, :SEQ_NO]).
      where(dq.statement params[:query]).
      limit(18).
      offset((params[:page] ||= 1).to_i - 1 > 1 ? (params[:page].to_i - 1) * 18 : 0).
      all
  end
end
