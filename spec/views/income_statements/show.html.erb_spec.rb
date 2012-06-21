# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../../spec_helper'

describe "/income_statements/show.html.erb" do
  include FiscalYearSpecHelper
  include ApplicationHelper
  
  before(:each) do
    assigns[:fiscal_year] = mock_fiscal_year
                                                  
    render "/income_statements/show"
  end
  
  [:sales, :interest_income, :purchases, :services, :depreciation,
   :other_expenses, :interest_expenses, :taxes].each do |account|     
    it "should show the result of #{account.to_s.humanize}" do    
      response.should have_tag("td", 
                       formatted(instance_variable_get("@#{account}").result.abs))
    end
  end

  it "should show totals for all sales subaccounts" do
    @subaccounts.each do |account|
      response.should have_tag("tr") do
        with_tag "td", account.title
        with_tag "td", sprintf("%.2f", account.result.abs / 100.0)
      end
    end
  end
  
  it "should show the total income" do
    response.should have_tag("th", formatted(@total_income.abs))
  end
  
  it "should show the total expenses" do
    response.should have_tag("th", formatted(@total_expenses.abs))
  end
  
  it "should show the net income before taxes" do
    response.should have_tag("th", "75000.00")
  end

  it "should show the net operating income" do
    response.should have_tag("th", "74000.00")
  end
  
  it "should show net income" do
    response.should have_tag("th", "69000.00")
  end
end
