require File.dirname(__FILE__) + '/../../spec_helper'

module NewSpecHelper
  def check_lines
    (1..4).each do |i|
      response.should have_tag("select#line_#{i}_account_id[name='line[#{i}][account_id]']")
      response.should have_tag("input#line_#{i}_debit")
      response.should have_tag("input#line_#{i}_credit")
    end
  end
  
  def set_assigns
    assigns[:accounts] = [@account]
    assigns[:lines] = @lines
    assigns[:fiscal_year] = @fiscal_year
    assigns[:event] = @event
  end
  
  def create_objects
    @event = Event.new
    @fiscal_year = mock_model(FiscalYear,
                              :to_param => "6")
    
    @account = mock_model(Account,
                          :title => "Bank account",
                          :id => 1)
  end
end

describe "/events/new.html.erb" do
  include EventsHelper
  include NewSpecHelper
  
  before do   
    @lines = []
    (1..4).each do |i|
      line = EventLine.new
      line.id = i                 
      @lines << line
    end    
    
    create_objects
    set_assigns
    render "/events/new.html.erb"
  end


  it "should render new form" do    
    response.should have_tag("form[action=?][method=post]", fiscal_year_events_path(@fiscal_year)) do
      with_tag("input[type=submit]")
      with_tag("input#event_description")
      with_tag("input#event_receipt_number")
      with_tag("input[type=text][name='event[event_date]']")
    end
  end
  
  it "should show four line forms using ids" do
    check_lines
  end
end

describe "/events/new.html.erb when lines don't have ids" do
  include EventsHelper
  include NewSpecHelper
  
  before do
    @lines = []
    (1..4).each do |i|
      line = EventLine.new
      @lines << line
    end
    create_objects
    set_assigns
    render "/events/new.html.erb"
  end
  
  it "should show four line forms using ids" do
    check_lines
  end
end