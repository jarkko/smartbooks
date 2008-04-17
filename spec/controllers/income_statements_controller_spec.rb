require File.dirname(__FILE__) + '/../spec_helper'

describe IncomeStatementsController do
  describe "GET show" do
    before(:each) do
      @fiscal_year = mock_model(FiscalYear)
      FiscalYear.stub!(:find).with("69").and_return(@fiscal_year)
    end
    
    def do_get
      get :show, :fiscal_year_id => "69"
    end
    
    it "should assign fiscal year" do
      do_get
      assigns[:fiscal_year].should == @fiscal_year
    end
  end
end
