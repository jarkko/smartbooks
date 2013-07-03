class PreliminaryEventsController < ApplicationController
  def index
    @fiscal_year = FiscalYear.find(params[:fiscal_year_id])
    @account = @fiscal_year.accounts.find(params[:account_id])
    @preliminary_events = @account.preliminary_events.unclaimed
  end
end
