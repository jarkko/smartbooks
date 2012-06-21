# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../../spec_helper'

describe "/events/index" do
  include EventsHelper

  before do
    event_98 = Event.new
    event_98.stub!(:id).and_return(98)
    event_98.stub!(:new_record?).and_return(false)

    event_99 = Event.new
    event_99.stub!(:id).and_return(99)
    event_99.stub!(:new_record?).and_return(false)

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

    assign :events, @events
    assign :fiscal_year, (@fy = stub_model(FiscalYear))
  end

  it "should render list of events" do
    render

    rendered.should have_selector('ul#events') do |ev|
      ev.should have_selector('li#event_98') do
        ev.should have_selector('h4', :content => "Paying the bill")

        ev.should have_selector('ul.event_lines') do
          ev.should have_selector('li', :content => "-20.00") do
            ev.should have_selector("a[href='#{fiscal_year_account_path(@fy, @account_1)}']", :content => @account_1.title)
          end
        end
      end
    end
  end
end

