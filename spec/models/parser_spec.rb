# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../../lib/sexp_parser'


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
                (account -1 "Tulos" ((account 300 "Tulot") (account 400 "Menot"
                                                              ((account 401 "Ostot"))))))
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

#describe SexpParser do
#  include SampleData
#
#  before(:each) do
#    @p = SexpParser.new(sample)
#  end
#
#  it "should create new fiscal year" do
#    lambda {
#      @p.import
#    }.should change(FiscalYear, :count)
#  end
#end

describe SexpParser, ", creating new fiscal year" do
  include SampleData

  before(:each) do
    @p = SexpParser.new(sample)

    @fy = stub_model(FiscalYear)
    FiscalYear.stub!(:create!).and_return(@fy)
    @fy.stub!(:create_account_from_array)

    @accounts = Sexpistol.new.parse_string(sample)[0][5][4][1..-1]
  end

  #it "should create new fiscal year with correct start date" do
  #  @fy.start_date.to_s.should == "2003-01-01"
  #end
  #
  #it "should create new fiscal year with correct end date" do
  #  @fy.end_date.to_s.should == "2003-12-31"
  #end
  #
  #it "should create new fiscal year with correct description" do
  #  @fy.description.should == "Esimerkkiyhdistys ery"
  #end

  it "should create new fiscal year with correct input" do
    Account.should_receive(:find_by_account_number).with("101").and_return(Account.new)
    FiscalYear.should_receive(:create!).with({
      :description => "Esimerkkiyhdistys ery",
      :start_date => "2003-01-01",
      :end_date => "2003-12-31"
    }).and_return(@fy)
    @p.import
  end

  it "should create seven new accounts" do
    @accounts.each do |account|
      @fy.should_receive(:create_account_from_array).with(account)
    end
    @p.import
  end

  #it "should create seven new accounts" do
  #  @fy.accounts.size.should == 7
  #end
  #
  #it "should create two new event lines" do
  #  EventLine.find(:all).size.should == 2
  #end
  #
  #it "should create a new event" do
  #  @fy.events.size.should == 1
  #end
end

describe FiscalYear, "create_account_from_array" do
  include SampleData

  before(:each) do
    @accounts = Sexpistol.new.parse_string(sample)[0][5][4][3]
    @fy = stub_model(FiscalYear)

    @sample_accounts =
      [{:account_number => "-1", :title => "Tulos", :parent => nil},
       {:account_number => "300", :title => "Tulot", :parent => :tulos},
       {:account_number => "400", :title => "Menot", :parent => :tulos},
       {:account_number => "401", :title => "Ostot", :parent => :menot}]
  end

  it "should create account with correct details" do
    @sample_accounts.each do |account|
      @fy.accounts.should_receive(:create!).with({
        :account_number => account[:account_number],
        :title => account[:title],
        :parent => account[:parent]
      }).and_return(account[:title].downcase.to_sym)
    end
    @fy.create_account_from_array(@accounts)
  end
end

describe Event, "calling parse_events" do
  include SampleData

  before(:each) do
    @events = Sexpistol.new.parse_string(sample)[0][5][5]
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
    @events = Sexpistol.new.parse_string(sample)[0][5][5]
  end

  it "should save event" do
    lambda {
      Event.parse_event(@fy, @events.first)
    }.should change(Event, :count).by(1)
  end

  it "should put the event to the correct fiscal year" do
    @event = Event.parse_event(@fy, @events.first)
    @fy.reload.events.should include(@event)
  end

  it "should add correct date" do
    @event = Event.parse_event(@fy, @events.first)
    @event.event_date.should == Date.new(2003,1,1)
  end

  it "should add correct description" do
    @event = Event.parse_event(@fy, @events.first)
    @event.description.should == "Tilinavaus"
  end

  it "should add two new event lines" do
    lambda {
      @event = Event.parse_event(@fy, @events.first)
    }.should change(EventLine, :count).by(2)
  end
end

