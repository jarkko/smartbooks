require File.dirname(__FILE__) + '/../spec_helper'
describe "GET /events general", :shared => true do
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should render index template" do
    do_get
    response.should render_template('index')
  end
  
  
  it "should assign the found events for the view" do
    do_get
    assigns[:events].should == [@event]
  end
end

describe EventsController, " handling GET /events" do
  include EventsControllerSpecHelper
  
  before do
    prepare_events
  end
  
  def do_get
    get :index, :fiscal_year_id => 1
  end
  
  it_should_behave_like "GET /events general"
  
  it "should find all events" do
    @events.should_receive(:find).with(:all, 
                        :order => "event_date, receipt_number",
                        :include => {:event_lines => :account}).and_return([@event])
    do_get
  end
end


describe EventsController, " handling GET /events with start_date" do
  include EventsControllerSpecHelper
  
  before do
    prepare_events
  end
  
  def do_get
    get :index, :fiscal_year_id => 1, :start_date => "2007/08/03"
  end

  it_should_behave_like "GET /events general"

  it "should find all events" do
    @events.should_receive(:find).with(:all, 
                      :order => "event_date, receipt_number",
                      :conditions => ["event_date >= ?", "2007-08-03"],
                      :include => {:event_lines => :account}).and_return([@event])
    do_get
  end
end

describe EventsController, " handling GET /events with end_date" do
  include EventsControllerSpecHelper
  
  before do
    prepare_events
  end
  
  def do_get
    get :index, :fiscal_year_id => 1, :end_date => "2007/08/03"
  end

  it_should_behave_like "GET /events general"

  it "should find all events" do
    @events.should_receive(:find).with(:all, 
                      :order => "event_date, receipt_number",
                      :conditions => ["event_date <= ?", "2007-08-03"],
                      :include => {:event_lines => :account}).and_return([@event])
    do_get
  end
end

describe EventsController, " handling GET /events with start_date and end_date" do
  include EventsControllerSpecHelper
  
  before do
    prepare_events
  end
  
  def do_get
    get :index, :fiscal_year_id => 1, :end_date => "2007/08/03", :start_date => "2007/08/01"
  end

  it_should_behave_like "GET /events general"

  it "should find all events" do
    @events.should_receive(:find).with(:all, 
                      :order => "event_date, receipt_number",
                      :conditions => ["event_date >= ? and event_date <= ?", "2007-08-01", "2007-08-03"],
                      :include => {:event_lines => :account}).and_return([@event])
    do_get
  end
end

describe EventsController, " handling GET /events/new" do
  before do
    @event = mock_model(Event)
    Event.stub!(:new).and_return(@event)
    @fiscal_year = stub_model(FiscalYear, :accounts => [])
    @fiscal_year.accounts.stub!(:find_for_dropdown).and_return(:accounts)
    FiscalYear.stub!(:find).and_return(@fiscal_year)
  end
  
  def do_get
    get :new, :fiscal_year_id => 1
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render new template" do
    do_get
    response.should render_template('new')
  end
  
  it "should create a new event" do
    Event.should_receive(:new).and_return(@event)
    do_get
  end
  
  it "should not save the new event" do
    @event.should_not_receive(:save)
    do_get
  end
  
  it "should assign the new event for the view" do
    do_get
    assigns[:event].should equal(@event)
  end
  
  it "should create four new event lines" do
    do_get
    assigns[:lines].size.should == 4
  end
  
  it "should get accounts from the current fiscal year" do
    do_get
    assigns[:accounts].should equal(@fiscal_year.accounts.find_for_dropdown)
  end
end

describe EventsController, " handling POST /events without fiscal year id" do
  include EventsControllerSpecHelper
  
  before(:each) do
    @event = mock_model(Event)
    Event.stub!(:new).and_return(@event)
  end
  
  it "should not create new event" do
    Event.should_not_receive(:new)
    do_post
  end
  
  it "should not save event" do
    @event.should_not_receive(:save)
    do_post
  end
  
  it "should return not found" do
    do_post
    response.response_code.should == 404
  end
end

describe EventsController, " handling POST /events" do
  include EventsControllerSpecHelper

  before(:each) do
    @fy = mock_model(FiscalYear, :id => 6)
    @fy.stub!(:to_param).and_return("6")
    FiscalYear.stub!(:find).and_return(@fy)
    @event = Event.new
    @event.stub!(:to_param).and_return("69")
    @event.stub!(:save!).and_return(true)
    @fy.stub!(:create_event).and_return(@event)
  end
  
  it "should create event" do
    @fy.should_receive(:create_event).
                    with(valid_attributes[:event].stringify_keys,
                         valid_attributes[:line]).
                    and_return(@event)
    do_post
  end
  
  it "should redirect to the event list" do
    do_post
    response.should redirect_to(fiscal_year_events_path(:fiscal_year_id => @fy, :anchor => "event_#{@event.to_param}"))
  end
  
  it "should show correct flash" do
    do_post
    flash[:notice].should == 'Event was successfully created.'
  end

  describe "when saving fails" do
    before(:each) do
      @event.stub!(:save!).
          and_raise(ActiveRecord::RecordInvalid.new(@event))
      @a1 = mock_model(Account, :title => "foo", :id => 1)
      @a2 = mock_model(Account, :title => "bar", :id => 2)
      @accounts = [@a1, @a2]
      Account.stub!(:find_for_dropdown).and_return(@accounts)      
    end
    
    it "should show the form again" do
      do_post
      response.should render_template("new")
    end

    it "should show correct flash" do
      do_post
      flash[:warning].should == 'Saving event failed.'
    end

    it "should set event lines correctly" do
      do_post
      assigns[:lines].should == @event.event_lines
    end

    it "should set accounts correctly" do
      do_post
      assigns[:accounts].should == @accounts
    end
  end
end
