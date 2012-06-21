# -*- encoding : utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EventsController do
  describe "route recognition" do
    it "generates params for #index" do
      {:get => "/fiscal_years/69/events"}.should route_to({:controller => "events", :action => "index", :fiscal_year_id => "69"})
    end

    it "generates params for #new" do
      {:get => "/fiscal_years/69/events/new"}.should route_to({:controller => "events", :action => "new", :fiscal_year_id => "69"})
    end

    it "generates params for #create" do
      {:post => "/fiscal_years/69/events"}.should route_to({:controller => "events", :action => "create", :fiscal_year_id => "69"})
    end
  end
end
