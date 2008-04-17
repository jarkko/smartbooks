class IncomeStatementsController < ApplicationController
  def show
    @fiscal_year = FiscalYear.find(params[:fiscal_year_id])                   
  end
end
