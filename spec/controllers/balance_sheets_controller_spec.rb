require File.dirname(__FILE__) + '/../spec_helper'

describe BalanceSheetsController do
  before(:each) do
    @fiscal_year = mock_model(FiscalYear)
    FiscalYear.stub!(:find).with("6").and_return(@fiscal_year)
    get 'show', :fiscal_year_id => "6"
  end

  describe "GET 'show'" do
    it "should be successful" do
      response.should be_success
    end
    
    it "should assign fiscal year" do
      assigns[:fiscal_year].should == @fiscal_year
    end
  end
end
