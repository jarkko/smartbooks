require File.dirname(__FILE__) + '/../spec_helper'

module SampleData
  def sample
    <<-END
    (identity "Tappio"
     version "versio 0.10"
     finances (fiscal-year "Esimerkkiyhdistys ery"
                           (date 2003 1 1)
    		       (date 2003 12 31)
    		       (account-map (account -1 "Vastaavaa" ((account 101 "Pankkitili")))
    		                    (account -1 "Vastattavaa" ((account 201 "Oma pääoma")))
    				    (account -1 "Tulos" ((account 300 "Tulot") (account 400 "Menot"))))
    		       ((event 1 (date 2003 1 1) "Tilinavaus" ((101 (money 123456)) (201 (money -123456)))))))
    END
  end
end

describe SexpParser, "fetch_date" do
  include SampleData
  
  before(:each) do
    @p = SexpParser.new(sample)
  end
  
  it "should return correct array" do
    @p.send(:fetch_date, ["date", 2007, 1, 31]).should == [2007, 1, 31]
  end
end

describe SexpParser do
  include SampleData
  
  before(:each) do
    @p = SexpParser.new(sample)
  end
  
  it "should create new fiscal year" do
    lambda {
      @p.import
    }.should change(FiscalYear, :count)
  end
end

describe SexpParser, ", creating new fiscal year" do
  include SampleData
  
  before(:each) do
    @p = SexpParser.new(sample)
    @p.import
    
    @fy = FiscalYear.find(:first, :order => "id desc")
  end
  
  it "should create new fiscal year with correct start date" do
    @fy.start_date.to_s.should == "2003-01-01"
  end
  
  it "should create new fiscal year with correct end date" do
    @fy.end_date.to_s.should == "2003-12-31"
  end
  
  it "should create new fiscal year with correct description" do
    @fy.description.should == "Esimerkkiyhdistys ery"
  end
  
  it "should create seven new accounts" do
    @fy.accounts.size.should == 7
  end
  
  it "should create two new event lines" do
    EventLine.find(:all).size.should == 2
  end
  
  it "should create a new event" do
    @fy.events.size.should == 1
  end
end

describe Account, "parsing" do
  fixtures :fiscal_years, :accounts
  
  include SampleData
  
  before(:each) do
    @sexp = Sexp.new(sample)
    @accounts = @sexp.getAry[5][4]
    @fy = fiscal_years(:year2007)
  end
  
  it "should create account with correct name" do
    Account.parse_array(@fy, @accounts.last.last.first)
    @fy.accounts.find(:first, :order => "id desc").title.should == "Tulot"
  end
  
  it "should create right amount of Accounts" do
    lambda {
      @accounts[1..-1].each do |account|
        Account.parse_array(@fy, account)
      end
    }.should change(Account, :count).by(7)
  end
  
  it "should create correct tree structure" do
    @accounts[1..-1].each do |account|
      Account.parse_array(@fy, account)
    end
    
    Account.find_by_title("Tulos").children.should == Account.find_all_by_title(["Tulot", "Menot"])
    Account.find_by_title("Vastattavaa").children.should == Account.find_all_by_title("Oma pääoma")
  end
end

describe Event, "calling parse_events" do  
  include SampleData
  
  before(:each) do
    @sexp = Sexp.new(sample)
    @events = @sexp.getAry[5][5]
    Event.stub!(:parse_event)
    @fy = mock_model(FiscalYear)
  end
  
  it "should call parse_event for all events" do
    Event.should_receive(:parse_event).once
    Event.parse_events(@fy, @events)
  end
end

describe Event, "calling parse_event" do
  include SampleData
  fixtures :fiscal_years, :accounts
  
  before(:each) do
    @fy = fiscal_years(:year2007)
    @sexp = Sexp.new(sample)
  end
  
  it "should save event" do
    lambda {
      Event.parse_event(@fy, @sexp.getAry[5][5].first)
    }.should change(Event, :count).by(1)
  end
  
  it "should put the event to the correct fiscal year" do
    @event = Event.parse_event(@fy, @sexp.getAry[5][5].first)
    @fy.reload.events.should include(@event)
  end
  
  it "should add correct date" do
    @event = Event.parse_event(@fy, @sexp.getAry[5][5].first)
    @event.event_date.should == Date.new(2003,1,1)
  end
  
  it "should add correct description" do
    @event = Event.parse_event(@fy, @sexp.getAry[5][5].first)
    @event.description.should == "Tilinavaus"
  end
  
  it "should add two new event lines" do
    lambda {
      @event = Event.parse_event(@fy, @sexp.getAry[5][5].first)
    }.should change(EventLine, :count).by(2)
  end
end

