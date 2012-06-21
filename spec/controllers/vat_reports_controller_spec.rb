# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

describe VatReportsController do
  before(:each) do
    @fy = mock_model(FiscalYear)
    FiscalYear.stub!(:find).with("1").and_return(@fy)
    @debt = mock_model(Account)
    @receivables = mock_model(Account)
    @fy.stub!(:vat_debt).and_return(@debt)
    @fy.stub!(:vat_receivables).and_return(@receivables)
  end
  
  def get_new(opts = {})
    get :new, {:fiscal_year_id => "1"}.merge(opts)
  end
  
  describe "GET new" do
    it "should populate fiscal year" do
      get_new
      assigns[:fiscal_year].should == @fy
    end
    
    it "should not populate debt" do
      get_new
      assigns[:debt].should == nil
    end
    
    describe "when month param set" do
      it "should populate debt" do
        get_new(:month => "11")
        assigns[:debt].should == @debt
      end
      
      it "should populate receivables" do
        get_new(:month => "11")
        assigns[:receivables].should == @receivables
      end
    end
  end
end
