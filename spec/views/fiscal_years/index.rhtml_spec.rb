require File.dirname(__FILE__) + '/../../spec_helper'

describe "/fiscal_years/index.rhtml" do
  include FiscalYearsHelper
  
  before do
    fiscal_year_98 = mock_model(FiscalYear)

    fiscal_year_99 = mock_model(FiscalYear)

    assigns[:fiscal_years] = [fiscal_year_98, fiscal_year_99]
  end

  it "should render list of fiscal_years" do
    render "/fiscal_years/index.rhtml"

  end
end

