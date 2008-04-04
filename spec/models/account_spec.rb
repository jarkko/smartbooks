require File.dirname(__FILE__) + '/../spec_helper'

describe Account do
  before(:each) do
    @account = Account.new
  end

  it "should be valid" do
     @account.should be_valid
  end
end

describe Account, ", calling virtual accounts" do
  fixtures :fiscal_years, :accounts, :events
  
  before(:each) do
    @virtual_accounts = Account.find_virtual
  end
  
  it "should fetch all accounts with number -1 and nothing else" do
    @virtual_accounts.should == [accounts(:vastaavaa),
                                accounts(:vastattavaa),
                                accounts(:tulos)]
  end
end

describe Account, "calling find_for_dropdown" do
  fixtures :fiscal_years, :accounts, :events
  
  before(:each) do
    @accounts = Account.find_for_dropdown
    @virtual_accounts = Account.find_virtual
    @all_accounts = Account.find(:all)
  end

  it "should order alphabetically" do
    @accounts.should == (@all_accounts - @virtual_accounts).sort_by(&:title)
  end
  
  it "should not have virtual accounts" do
    (@accounts & @virtual_accounts).should be_empty
  end
end