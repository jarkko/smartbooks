require File.dirname(__FILE__) + '/../../spec_helper'

describe "/fiscal_years/new.html.erb" do
  include FiscalYearsHelper
  include FiscalYearSpecHelper
  
  before do
    @fiscal_year = mock_fiscal_year
    @fiscal_year.stub!(:new_record?).and_return(true)
    assigns[:fiscal_year] = @fiscal_year
    assigns[:fiscal_years] = @fiscal_years = [mock_fiscal_year, mock_fiscal_year]
  end

  it "should render new form" do
    render "/fiscal_years/new"
    response.should have_tag("form[action=?][method=post]", fiscal_years_path) do
      with_tag "input[type=text][name='fiscal_year[description]']"
      with_tag "input[type=text][name='fiscal_year[start_date]'][class=date]"
      with_tag "input[type=text][name='fiscal_year[end_date]'][class=date]"
      with_tag "select[name='fiscal_year[copy_accounts_from]']" do
        @fiscal_years.each do |fy|
          with_tag "option[value=#{fy.id}]", fy.description
        end
      end
      with_tag "input[type=submit][value='Create fiscal year']"
    end
  end
end