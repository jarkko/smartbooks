require File.dirname(__FILE__) + '/../../spec_helper'

describe "/fiscal_years/edit.rhtml" do
  include FiscalYearsHelper
  
  before do
    @fiscal_year = mock_model(FiscalYear)
    assigns[:fiscal_year] = @fiscal_year
  end

  it "should render edit form" do
    render "/fiscal_years/edit.rhtml"
    
    response.should have_tag("form[action=#{fiscal_year_path(@fiscal_year)}][method=post]") do
    end
  end
end


