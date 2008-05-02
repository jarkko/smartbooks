require File.dirname(__FILE__) + '/../spec_helper'

describe FiscalYear do
  before(:each) do
    @fiscal_year = FiscalYear.new

    FiscalYear.account_names.each do |key, name|
      instance_variable_set("@#{key}", mock_model(Account, :title => name))
      @fiscal_year.accounts.
        stub!(:find_by_title).with(name).and_return(instance_variable_get("@#{key}"))
    end

    @vat_debt.stub!(:total).with(:month => 11).and_return(-60000)
    @vat_receivables.stub!(:total).with(:month => 1..11).and_return(50000)
  end

  it "should be valid" do
     @fiscal_year.should be_valid
  end
  
  FiscalYear.account_names.each do |key, name|
    describe "#{key}" do
      it "should return account '#{name}'" do
        @fiscal_year.send(key).should == instance_variable_get("@#{key}")
      end
    end
  end
  
  describe "total_income" do
    before(:each) do
      @sales.stub!(:result).and_return(6900)
      @interest_income.stub!(:result).and_return(1200)
    end
    
    it "should return sales + interest income" do
      @fiscal_year.total_income.should == 8100
    end
  end
  
  describe "total_expenses" do
    before(:each) do
      [@purchases, @services, @depreciation, @other_expenses, @interest_expenses].each do |account|
        account.stub!(:result).and_return(10)
      end
    end

    it "should return the sum of all expenses" do
      @fiscal_year.total_expenses.should == 50
    end
  end
  
  describe "net_income_before_taxes" do
    before(:each) do
      @fiscal_year.stub!(:total_income).and_return(-10000)
      @fiscal_year.stub!(:total_expenses).and_return(5000)
    end
    
    it "should return total income - total expenses" do
      @fiscal_year.net_income_before_taxes.should == 5000
    end
  end
  
  describe "net_operating_income" do
    before(:each) do
      @fiscal_year.stub!(:net_income_before_taxes).and_return(5000)
      @fiscal_year.stub!(:interest_income).and_return(@interest_income)
      @interest_income.stub!(:result).and_return(-100)
    end
    
    it "should return net income before taxes - interest income" do
      @fiscal_year.net_operating_income.should == 4900
    end
  end
  
  describe "net_income" do
    before(:each) do
      @fiscal_year.stub!(:net_income_before_taxes).and_return(5000)
      @fiscal_year.stub!(:taxes).and_return(@taxes)
      @taxes.stub!(:result).and_return(500)
    end
    
    it "should return net income before taxes - taxes" do
      @fiscal_year.net_income.should == 4500
    end
  end
  
  describe "payable_vat_for" do
    describe "when payables greater than deductions" do
      it "should return the formatted sum" do
        @fiscal_year.payable_vat_for("11").should == "100.00"
      end
    end
    
    describe "when deductions greater than payables" do
      before(:each) do
        @vat_receivables.stub!(:total).with(:month => 1..11).and_return(70000)
      end
      
      it "should return zero" do
        @fiscal_year.payable_vat_for("11").should == "0.00"
      end
    end
  end
  
  describe "transferred_vat_receivables_for" do    
    describe "when payables greater than deductions" do
      it "should return zero" do
        @fiscal_year.transferred_vat_receivables_for("11").should == "0.00"
      end
    end
    
    describe "when deductions greater than payables" do
      before(:each) do
        @vat_receivables.stub!(:total).with(:month => 1..11).and_return(70000)
      end
      
      it "should return the actual amount" do
        @fiscal_year.transferred_vat_receivables_for("11").should == "100.00"
      end
    end
  end
  
  describe "private_equity" do    
    describe "when investments > withdraws" do
      before(:each) do
        @private_equity.stub!(:result).and_return(-63000)
      end
      
      it "should return positive balance" do
        @fiscal_year.private_equity_result.should == 63000
      end
    end
    
    describe "when investments < withdraws" do
      before(:each) do
        @private_equity.stub!(:result).and_return(63000)
      end
      
      it "should return positive balance" do
        @fiscal_year.private_equity_result.should == -63000
      end
    end
  end
  
  describe "liabilities" do
    before(:each) do
      @stockholders_equity.stub!(:result).and_return(-900000)
      @private_equity.stub!(:result).and_return(-3700000)
      @fiscal_year.stub!(:net_income).and_return(2490000)
      @current_liabilities.stub!(:result).and_return(-480000)
    end
    
    it "should return stockholder's equity + private equity + net income/loss +
        short term liabilities" do
      @fiscal_year.liabilities_result.should == 
          (@fiscal_year.stockholders_equity.result.abs +
           @fiscal_year.private_equity_result +
           @fiscal_year.net_income +
           @fiscal_year.current_liabilities.result.abs)
    end
  end
end
