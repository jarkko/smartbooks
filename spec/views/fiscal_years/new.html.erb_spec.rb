require File.dirname(__FILE__) + '/../../spec_helper'

describe "/fiscal_years/new.rhtml" do
  include FiscalYearsHelper
  
  before do
    @fiscal_year = mock_model(FiscalYear)
    @fiscal_year.stub!(:new_record?).and_return(true)
    assigns[:fiscal_year] = @fiscal_year
  end

  it "should render new form" do
    render "/fiscal_years/new.rhtml"
    
    response.should have_tag("form[action=?][method=post]", fiscal_years_path) do
    end
  end
end


