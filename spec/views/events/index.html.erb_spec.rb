require File.dirname(__FILE__) + '/../../spec_helper'

describe "/events/index.html.erb" do
  include EventsHelper
  
  before do
    event_98 = Event.new
    event_98.stub!(:id).and_return(98)
    
    event_99 = Event.new
    event_99.stub!(:id).and_return(99)
    
    el_1 = EventLine.new
    el_1.stub!(:amount).and_return(-2000)
    el_2 = EventLine.new
    el_2.stub!(:amount).and_return(2000)
    
    @event_lines = [el_1, el_2]
    
    @account_1 = mock_model(Account)
    @account_1.stub!(:title).and_return("Pankkitili")

    @account_2 = mock_model(Account)
    @account_2.stub!(:title).and_return("Menot")
    
    el_1.stub!(:account).and_return(@account_1)
    el_2.stub!(:account).and_return(@account_2)
    
    @events = [event_98, event_99]
    @events.each do |event|
      event.stub!(:description).and_return("Paying the bill")
      event.stub!(:event_date).and_return(Date.today)
      event.stub!(:receipt_number).and_return(event.id)
      event.stub!(:event_lines).and_return(@event_lines)
    end
    
    assigns[:events] = @events
    assigns[:fiscal_year] = @fy = stub_model(FiscalYear)
  end

  it "should render list of events" do
    render "/events/index.html.erb"

    response.should have_tag('ul#events') do
      with_tag('li#event_98') do
        with_tag('h4', /Paying the bill/)
        
        with_tag('ul.event_lines') do
          with_tag('li', /-20\.00/) do
            with_tag "a[href=#{fiscal_year_account_path(@fy, @account_1)}]", @account_1.title
          end
        end
      end
    end
  end
end

