require File.dirname(__FILE__) + '/../spec_helper'

module EventSpecHelp
  private
  def valid_attributes
    {:fiscal_year_id => 1, :receipt_number => 69, 
     :event_date => Date.today, :description => "Foo"}
  end
end

describe Event, ", with lines whose amounts don't result in zero" do
  include EventSpecHelp
  
  before(:each) do
    @event = Event.new(valid_attributes)
    @event.event_lines.build(:amount => 1000)
    @event.event_lines.build(:amount => -900)
    @event.valid?
  end

  it "should not be valid" do
     @event.should_not be_valid
  end
  
  it "should have errors on event_lines" do
    @event.errors.on(:event_lines).should_not be_empty
  end
end

describe Event, ", with lines adding up to zero" do
  include EventSpecHelp
  
  before(:each) do
    @event = Event.new(valid_attributes.except(:receipt_number))
    @event.event_lines.build(:amount => 950, :account_id => 2)
    @event.event_lines.build(:amount => -800, :account_id => 2)
    @event.event_lines.build(:amount => -150, :account_id => 2)
    
    Event.stub!(:next_receipt_number)
  end

  it "should be valid" do
    @event.should be_valid
  end
  
  it "should set receipt_number when nil" do
    Event.should_receive(:next_receipt_number).and_return(999)
    @event.save.should == true
    @event.receipt_number.should == 999
  end
end

describe Event, ", without valid date" do
  include EventSpecHelp
  
  before(:each) do
    @event = Event.new(valid_attributes.except(:event_date))
  end
  
  it "should not be valid" do
    @event.should_not be_valid
  end
end

describe Event, "calling next_receipt_number with existing events" do
  fixtures :events
  
  it "should return next free receipt_number" do
    Event.next_receipt_number.should == Event.maximum('receipt_number') + 1
  end
end