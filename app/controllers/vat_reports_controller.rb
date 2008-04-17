class VatReportsController < ApplicationController
  def new
    @fiscal_year = FiscalYear.find(params[:fiscal_year_id])
    render unless params[:month]
    
    @debt = @fiscal_year.vat_debt
    @receivables = @fiscal_year.vat_receivables
  end
end
