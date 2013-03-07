class MassQueryController < ApplicationController
  def index
    dq = dynamic_query Match::R201Cd2009
    @panel = dq.panel(params[:query])
    @records = Match::R201Cd2009.
      where(dq.statement(params[:query])).
      paginate(:page => params[:page], :per_page => 20)
  end
end
