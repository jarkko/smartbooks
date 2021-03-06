# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

describe EventsController do
  include EventsControllerSpecHelper

  describe "handling GET /events" do
    share_examples_for "GET /events general" do
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

    before do
      prepare_events
    end

    def do_get
      get :index, :fiscal_year_id => 1
    end

    it_should_behave_like "GET /events general"

    it "should find all events" do
      @fy.should_receive(:ordered_events).with(nil, nil).and_return([@event])
      do_get
    end

    describe "with start_date" do
      def do_get
        get :index, :fiscal_year_id => 1, :start_date => "2007/08/03"
      end

      it_should_behave_like "GET /events general"

      it "should find all events" do
        @fy.should_receive(:ordered_events).with("2007/08/03", nil).and_return([@event])
        do_get
      end
    end

    describe "with end_date" do
      def do_get
        get :index, :fiscal_year_id => 1, :end_date => "2007/08/03"
      end

      it_should_behave_like "GET /events general"

      it "should find all events" do
        @fy.should_receive(:ordered_events).with(nil, "2007/08/03").and_return([@event])

        do_get
      end
    end

    describe "with start_date and end_date" do
      def do_get
        get :index, :fiscal_year_id => 1, :end_date => "2007/08/03", :start_date => "2007/08/01"
      end

      it_should_behave_like "GET /events general"

      it "should find all events" do
        @fy.should_receive(:ordered_events).with("2007/08/01", "2007/08/03").and_return([@event])
        do_get
      end
    end
  end

  describe "handling GET /events/new" do
    before do
      @event = FactoryGirl.build_stubbed(:event)
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

  describe "handling POST /events" do
    before(:each) do
      @fy = FactoryGirl.build_stubbed(:fiscal_year, :id => 6)
      @event = FactoryGirl.build_stubbed(:event, :id => "69")
      @fy.stub!(:create_event).and_return(@event)
    end

    describe "when fiscal year not found" do
      before(:each) do
        @event = mock_model(Event)
        Event.stub!(:new).and_return(@event)
        FiscalYear.should_receive(:find).with("69").and_return(nil)
      end

      it "should not create new event" do
        Event.should_not_receive(:new)
        do_post(:fiscal_year_id => "69")
      end

      it "should not save event" do
        @event.should_not_receive(:save)
        do_post(:fiscal_year_id => "69")
      end

      it "should return not found" do
        do_post(:fiscal_year_id => "69")
        response.response_code.should == 404
      end
    end

    describe "successfully" do
      before(:each) do
        FiscalYear.should_receive(:find).and_return(@fy)
        @event.should_receive(:save!).and_return(true)
      end

      it "should create event" do
        @fy.should_receive(:create_event).
                        with(valid_attributes[:event].stringify_keys,
                             valid_attributes[:line]).
                        and_return(@event)
        do_post(:fiscal_year_id => @fy.id)
      end

      it "should redirect to the event list" do
        do_post(:fiscal_year_id => @fy.id)
        response.should redirect_to(fiscal_year_events_path(:fiscal_year_id => @fy, :anchor => "event_#{@event.to_param}"))
      end

      it "should show correct flash" do
        do_post(:fiscal_year_id => @fy.id)
        flash[:notice].should == 'Event was successfully created.'
      end
    end

    describe "when saving fails" do
      before(:each) do
        FiscalYear.should_receive(:find).and_return(@fy)
        @event.should_receive(:save!).
            and_raise(ActiveRecord::RecordInvalid.new(@event))
        @a1 = mock_model(Account, :title => "foo", :id => 1)
        @a2 = mock_model(Account, :title => "bar", :id => 2)
        @accounts = [@a1, @a2]
        Account.stub!(:find_for_dropdown).and_return(@accounts)
      end

      it "should show the form again" do
        do_post(:fiscal_year_id => @fy.id)
        response.should render_template("new")
      end

      it "should show correct flash" do
        do_post(:fiscal_year_id => @fy.id)
        flash[:warning].should == 'Saving event failed.'
      end

      it "should set event lines correctly" do
        do_post(:fiscal_year_id => @fy.id)
        assigns[:lines].should == @event.event_lines
      end

      it "should set accounts correctly" do
        do_post(:fiscal_year_id => @fy.id)
        assigns[:accounts].should == @accounts
      end
    end
  end

  def prepare_for_edit
    @event = FactoryGirl.build_stubbed(:event, :id => 69)
    Event.stub!(:find).with("69").and_return(@event)
    @event_lines = []

    amt = rand(100)
    2.times do |i|
      factor = -1 ** i
      event_line = FactoryGirl.build_stubbed(:event_line, :amount => amt * factor)
      @event_lines << event_line
    end
    @event.stub!(:event_lines).and_return(@event_lines)

    @fiscal_year = stub_model(FiscalYear, :accounts => [])
    @fiscal_year.stub!(:events).and_return([])
    @fiscal_year.events.stub!(:find).and_return(@event)
    @fiscal_year.accounts.stub!(:find_for_dropdown).and_return(:accounts)
    FiscalYear.stub!(:find).and_return(@fiscal_year)
  end

  describe "handling GET /events/edit" do
    before do
      prepare_for_edit
    end

    def do_get
      get :edit, :fiscal_year_id => 1, :id => 69
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end

    it "should create a new event" do
      @fiscal_year.events.should_receive(:find).with("69").and_return(@event)
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

  describe "handling PUT /events/update" do
    before do
      prepare_for_edit
    end

    it "should redirect to events page" do
      @event.should_receive(:update_attributes!).
                      with(valid_attributes[:event].stringify_keys)
      @event.should_receive(:update_lines!).with(valid_attributes[:line])
      do_put
      response.should redirect_to(fiscal_year_events_path(:fiscal_year_id => @fiscal_year, :anchor => "event_#{@event.id}"))
    end
  end
end
