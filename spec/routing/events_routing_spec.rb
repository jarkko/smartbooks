require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EventsController do
  describe "route generation" do
    it "should map { :controller => 'events', :action => 'index' } to /events" do
      route_for(:controller => "events", :action => "index", :fiscal_year_id => "69").should == "/fiscal_years/69/events"
    end

    it "should map { :controller => 'events', :action => 'new' } to /events/new" do
      route_for(:controller => "events", :action => "new", :fiscal_year_id => "69").should == "/fiscal_years/69/events/new"
    end

    it "should map create" do
      route_for(:controller => "events", :action => "create", :fiscal_year_id => "69").should == {:path => "/fiscal_years/69/events", :method => :post}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/fiscal_years/69/events").should == {:controller => "events", :action => "index", :fiscal_year_id => "69"}
    end
  
    it "generates params for #new" do
      params_from(:get, "/fiscal_years/69/events/new").should == {:controller => "events", :action => "new", :fiscal_year_id => "69"}
    end
  
    it "generates params for #create" do
      params_from(:post, "/fiscal_years/69/events").should == {:controller => "events", :action => "create", :fiscal_year_id => "69"}
    end
  end
end
