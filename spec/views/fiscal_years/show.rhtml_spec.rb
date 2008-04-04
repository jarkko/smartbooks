require File.dirname(__FILE__) + '/../../spec_helper'

describe "/fiscal_years/show.rhtml" do
  include FiscalYearsHelper
  
  before do
    @fiscal_year = mock_model(FiscalYear)

    assigns[:fiscal_year] = @fiscal_year
  end

  it "should render attributes in <p>" do
    render "/fiscal_years/show.rhtml"

  end
end

