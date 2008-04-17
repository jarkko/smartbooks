require File.dirname(__FILE__) + '/../../spec_helper'

describe "/income_statements/show.html.erb" do
  before(:each) do
    assigns[:fiscal_year] = @fiscal_year = mock_model(FiscalYear,
                                                      :net_income_before_taxes => 7500000,
                                                      :net_operating_income => 7400000,
                                                      :net_income => 6900000)
    @sales = mock_model(Account,
                        :title => "Myyntituotot",
                        :result => -69000)
    @fiscal_year.stub!(:sales).and_return(@sales)
                                 
    @subaccounts = [mock_model(Account, :title => "Myynti 22%", :result => -54000),
      mock_model(Account, :title => "Myynti 0%", :result => -15000)]  
    @sales.stub!(:children).and_return(@subaccounts)
    
    @interest_income = mock_model(Account,
                              :title => "Muut korko ja rahoitustuotot",
                              :result => -13000)
    @fiscal_year.stub!(:interest_income).and_return(@interest_income)
                              
    @fiscal_year.stub!(:total_income).and_return(@sales.result + @interest_income.result)
    
    
    @purchases = mock_model(Account,
        :title => "Aineet, tarvikkeet ja tavarat",
        :result => 1000)
    @fiscal_year.stub!(:purchases).and_return(@purchases)
    
                              
    @services = mock_model(Account,
         :title => "Palvelut",
         :result => 500)
    @fiscal_year.stub!(:services).and_return(@services)
    
    @depreciation = mock_model(Account,
                               :title => "Poistot",
                               :result => 450)
    @fiscal_year.stub!(:depreciation).and_return(@depreciation)
    
    @other_expenses = mock_model(Account,
                                 :title => "Liiketoiminnan muut kulut",
                                 :result => 400)
    @fiscal_year.stub!(:other_expenses).and_return(@other_expenses)
                              
    @interest_expenses = mock_model(Account,
                           :title => "Korkokulut ja muut rahoituskulut",
                           :result => 300)
    @fiscal_year.stub!(:interest_expenses).and_return(@interest_expenses)
    
    @total_expenses = @purchases.result +
                      @services.result +
                      @depreciation.result +
                      @other_expenses.result +
                      @interest_expenses.result
                      
    @fiscal_year.stub!(:total_expenses).and_return(@total_expenses)
    
    @taxes = mock_model(Account,
                        :title => "Verot",
                        :result => 6900)
    @fiscal_year.stub!(:taxes).and_return(@taxes)
                                                  
    render "/income_statements/show"
  end
  
  it "should show the result of all sales" do
    response.should have_tag("td", "690.00")
  end
  
  it "should show totals for all sales subaccounts" do
    @subaccounts.each do |account|
      response.should have_tag("tr") do
        with_tag "td", account.title
        with_tag "td", sprintf("%.2f", account.result.abs / 100.0)
      end
    end
  end
  
  it "should show the result of interest income" do
    response.should have_tag("td", "130.00")
  end
  
  it "should show the total income" do
    response.should have_tag("th", "820.00")
  end
  
  it "should show purchases" do
    response.should have_tag("td", "10.00")
  end
  
  it "should show services" do
    response.should have_tag("td", "5.00")
  end
  
  it "should show depreciation" do
    response.should have_tag("td", "4.50")
  end

  it "should show other expenses" do
    response.should have_tag("td", "4.00")
  end
  
  it "should show interest expenses" do
    response.should have_tag("td", "3.00")
  end
  
  it "should show the total expenses" do
    response.should have_tag("th", "26.50")
  end
  
  it "should show the net income before taxes" do
    response.should have_tag("th", "75000.00")
  end

  it "should show the net operating income" do
    response.should have_tag("th", "74000.00")
  end
  
  it "should show taxes" do
    response.should have_tag("td", "69.00")
  end
  
  it "should show net income" do
    response.should have_tag("th", "69000.00")
  end
end