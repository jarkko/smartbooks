# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../../spec_helper'

describe "/accounts/show" do
  include AccountsHelper

  before do
    assigns[:fiscal_year] = @fiscal_year = mock_model(FiscalYear, :description => "2007")

    @account = mock_model(Account, :title => "Palvelut", :total => "+56.00")
    @account.stub!(:total).with(:formatted => true, :only => :credit).and_return("-20.00")
    @account.stub!(:total).with(:formatted => true, :only => :debit).and_return("+76.00")
    assigns[:account] = @account

    @event = mock_model(Event, :description => "Bankruptcy",
                               :event_date => Date.today,
                               :receipt_number => 69)
    @line1 = mock_model(EventLine, :event => @event, :sum => "+69.00")
    @line2 = mock_model(EventLine, :event => @event, :sum => "-13.00")

    @event_lines = [@line1, @line2]

    @account.stub!(:event_lines).and_return(@event_lines)
    render
  end

  it "should show the account name in a heading" do
    rendered.should have_selector("h1", :content => @account.title)
  end

  it "should show a list of events" do
    @event_lines.each do |line|
      rendered.should have_selector("tr") do |el|
        el.should have_selector "td", :content => line.event.event_date.to_s
        el.should have_selector "td", :content => line.event.receipt_number.to_s
        el.should have_selector "td", :content => line.event.description
        el.should have_selector "td", :content => line.sum
      end
    end
  end

  it "should show total debit" do
    rendered.should have_selector("#total_debit", :content => "+76.00")
  end

  it "should show total credit" do
    rendered.should have_selector("#total_credit", :content => "-20.00")
  end

  it "should show a total for the account" do
    rendered.should have_selector("#total", :content => "+56.00")
  end
end
