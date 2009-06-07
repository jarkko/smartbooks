require File.dirname(__FILE__) + '/../../spec_helper'

describe "/fiscal_years/index.html.erb" do
  include FiscalYearsHelper
  include FiscalYearSpecHelper
  
  before do
    assigns[:fiscal_years] = @fiscal_years = [mock_fiscal_year, mock_fiscal_year]
    render "/fiscal_years/index"
  end

  it "should render index page" do
    response.should have_tag("#fiscal_years") do
      @fiscal_years.each do |fy|
        with_tag "li#fiscal_year_#{fy.id}" do
          with_tag "a[href=?]", fiscal_year_events_path(fy)
        end
      end
    end
    
    #response.should have_tag("form[action=?][method=post]", fiscal_years_path) do
    #  with_tag "input[type=text][name='fiscal_year[description]']"
    #  with_tag "input.date[type=text][name='fiscal_year[start_date]']"
    #  with_tag "input.date[type=text][name='fiscal_year[end_date]']"
    #  with_tag "select[name='fiscal_year[copy_accounts_from]']" do
    #    @fiscal_years.each do |fy|
    #      with_tag "option[value=#{fy.id}]", fy.description
    #    end
    #  end
    #  with_tag "input[type=checkbox][name='fiscal_year[copy_balance]']"
    #  with_tag "input[type=submit][value='Create fiscal year']"
    #end
  end
end