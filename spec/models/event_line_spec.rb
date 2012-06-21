# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

#describe EventLine do
#  fixtures :fiscal_years, :accounts, :events
#  
#  before(:each) do
#    @event_line = EventLine.new
#  end
#
#  it "should not be valid without account id" do
#    @event_line.should_not be_valid
#  end
#  
#  it "should not be valid with a virtual account id" do
#    @event_line.account_id = 1
#    @event_line.should_not be_valid
#  end
#  
#  it "should be valid with both event and account id assigned" do
#    @event_line.account_id = 2
#    @event_line.should be_valid
#  end
#end
#
#describe EventLine, "new with credit" do
#  before(:each) do
#    @el = EventLine.new(:credit => 100)
#  end
#  
#  it "should create negative amount" do
#    @el.amount.should == -10000
#  end
#end
#
#describe EventLine, "new with debit" do
#  before(:each) do
#    @el = EventLine.new(:debit => 100)
#  end
#  
#  it "should create positive amount" do
#    @el.amount.should == 10000
#  end
#end
#
#describe EventLine, "new with both debit and credit" do
#  before(:each) do
#    @el = EventLine.new(:credit => 150, :debit => 200)
#  end
#  
#  it "should create amount that equals debit - credit" do
#    @el.amount.should == 5000
#  end
#end
#
#describe EventLine, "new with both debit and credit, with amounts as strings" do
#  before(:each) do
#    @el = EventLine.new(:credit => "150", :debit => "200")
#  end
#  
#  it "should create amount that equals debit - credit" do
#    @el.amount.should == 5000
#  end
#end
#
#describe EventLine, "setting positive credit" do
#  before(:each) do
#    @el = EventLine.new
#    @el.credit = 600
#  end
#  
#  it "should set amount as negative" do
#    @el.amount.should == -60000
#  end
#  
#  it "should show credit as positive" do
#    @el.credit.should == 600
#  end
#  
#  it "should show nothing as debit" do
#    @el.debit.should be_empty
#  end
#end
#
#describe EventLine, "setting negative credit" do
#  before(:each) do
#    @el = EventLine.new
#    @el.credit = -600
#  end
#  
#  it "should set amount as positive" do
#    @el.amount.should == 60000
#  end
#  
#  it "should show debit as positive" do
#    @el.debit.should == 600
#  end
#  
#  it "should show nothing as credit" do
#    @el.credit.should be_empty
#  end
#end
#
#describe EventLine, "setting positive debit" do
#  before(:each) do
#    @el = EventLine.new
#    @el.debit = 600
#  end
#  
#  it "should set amount as positive" do
#    @el.amount.should == 60000
#  end
#  
#  it "should show debit as positive" do
#    @el.debit.should == 600
#  end
#  
#  it "should show nothing as credit" do
#    @el.credit.should be_empty
#  end
#end
#
#describe EventLine, "setting negative debit" do
#  before(:each) do
#    @el = EventLine.new
#    @el.debit = -600
#  end
#  
#  it "should set amount as negative" do
#    @el.amount.should == -60000
#  end
#  
#  it "should show credit as positive" do
#    @el.credit.should == 600
#  end
#  
#  it "should show nothing as debit" do
#    @el.debit.should be_empty
#  end
#end
#
#describe EventLine, "setting debit with a comma as a separator" do
#  before(:each) do
#    @el = EventLine.new
#    @el.debit = "-600,50"
#  end
#  
#  it "should set amount as negative" do
#    @el.amount.should == -60050
#  end
#  
#  it "should show credit as positive" do
#    @el.credit.should == 600.50
#  end
#  
#  it "should show nothing as debit" do
#    @el.debit.should be_empty
#  end
#end
#
#describe EventLine, "setting negative credit with a comma as a separator" do
#  before(:each) do
#    @el = EventLine.new
#    @el.credit = "-600,75"
#  end
#  
#  it "should set amount as positive" do
#    @el.amount.should == 60075
#  end
#  
#  it "should show debit as positive" do
#    @el.debit.should == 600.75
#  end
#  
#  it "should show nothing as credit" do
#    @el.credit.should be_empty
#  end
#end

describe EventLine do
  describe "saving" do
    it "should work" do
      e = EventLine.new
      e.save
    end
  end
end
