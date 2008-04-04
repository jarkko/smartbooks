require File.dirname(__FILE__) + '/../spec_helper'

describe FiscalYear do
  before(:each) do
    @fiscal_year = FiscalYear.new
  end

  it "should be valid" do
     @fiscal_year.should be_valid
  end
end
