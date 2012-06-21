# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../../spec_helper'

describe "/events/edit.html.erb" do
  include EventsHelper

  def check_lines
    (1..4).each do |i|
      rendered.should have_selector("select#line_#{i}_account_id[name='line[#{i}][account_id]']")
      rendered.should have_selector("input#line_#{i}_debit")
      rendered.should have_selector("input#line_#{i}_credit")
    end
  end

  def set_assigns
    assigns[:accounts] = [@account]
    assigns[:lines] = @lines
    assigns[:fiscal_year] = @fiscal_year
    assigns[:event] = @event
  end

  def create_objects
    @event = FactoryGirl.build_stubbed(:event, :id => "100")
    @event.stub!(:new_record?).and_return(false)
    @fiscal_year = FactoryGirl.build(:fiscal_year)
    @account = FactoryGirl.build_stubbed(:account)
  end

  describe "when lines have an id" do
    before do
      @lines = []
      (1..4).each do |i|
        line = EventLine.new
        line.id = i
        @lines << line
      end

      create_objects
      set_assigns
      render
    end

    it "should render new form" do
      rendered.should have_selector("form[action=?][method=post]", fiscal_year_event_path(@fiscal_year, @event)) do |el|
        el.should have_selector("input[type=submit]")
        el.should have_selector("input#event_description")
        el.should have_selector("input#event_receipt_number")
        el.should have_selector("input[type=text][name='event[event_date]']")
      end
    end

    it "should show four line forms using ids" do
      check_lines
    end
  end
end
