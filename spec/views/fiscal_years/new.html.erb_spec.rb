require File.dirname(__FILE__) + '/../../spec_helper'

describe "/fiscal_years/new.html.erb" do
  include FiscalYearsHelper
  include FiscalYearSpecHelper
  
  before do
    @fiscal_year = mock_fiscal_year
    @fiscal_year.stub!(:new_record?).and_return(true)
    assigns[:fiscal_year] = @fiscal_year
  end

  it "should render new form" do
    render "/fiscal_years/new"
    response.should have_tag("form[action=?][method=post]", fiscal_years_path) do
      with_tag "input[type=text][name='fiscal_year[description]']"
    end
  end
end


