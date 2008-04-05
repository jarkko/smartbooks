require File.dirname(__FILE__) + '/../../spec_helper'

describe "/accounts/show.rhtml" do
  include AccountsHelper
  
  before do
    assigns[:fiscal_year] = @fiscal_year = mock_model(FiscalYear, :description => "2007")
    
    @account = mock_model(Account, :title => "Palvelut", :total => "+56.00")
    assigns[:account] = @account
    
    @event = mock_model(Event, :description => "Bankruptcy",
                               :event_date => Date.today,
                               :receipt_number => 69)
    @line1 = mock_model(EventLine, :event => @event, :sum => "+69.00")
    @line2 = mock_model(EventLine, :event => @event, :sum => "-13.00")
    
    @event_lines = [@line1, @line2]
    
    @account.stub!(:event_lines).and_return(@event_lines)
    render "accounts/show"
  end

  it "should show the account name in a heading" do
    response.should have_tag("h1", @account.title)
  end
  
  it "should show a list of events" do
    @event_lines.each do |line|
      response.should have_tag("tr") do
        with_tag "td", line.event.event_date.to_s
        with_tag "td", line.event.receipt_number.to_s
        with_tag "td", line.event.description
        with_tag "td", line.sum
      end
    end
  end
  
  it "should show a total for the account" do
    response.should have_tag("#total", "+56.00")
  end
end