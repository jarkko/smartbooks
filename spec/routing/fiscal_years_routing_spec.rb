require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FiscalYearsController do
  describe "#route_for" do
    it "should map { :controller => 'fiscal_years', :action => 'index' } to /fiscal_years" do
      route_for(:controller => "fiscal_years", :action => "index").should == {:path => "/fiscal_years"}
    end

    it "should map { :controller => 'fiscal_years', :action => 'new' } to /fiscal_years/new" do
      route_for(:controller => "fiscal_years", :action => "new").should == "/fiscal_years/new"
    end

    it "should map { :controller => 'fiscal_years', :action => 'show', :id => 1 } to /fiscal_years/1" do
      route_for(:controller => "fiscal_years", :action => "show", :id => "1").should == "/fiscal_years/1"
    end

    it "should map { :controller => 'fiscal_years', :action => 'edit', :id => 1 } to /fiscal_years/1;edit" do
      route_for(:controller => "fiscal_years", :action => "edit", :id => "1").should == "/fiscal_years/1/edit"
    end

    it "should map { :controller => 'fiscal_years', :action => 'update', :id => 1} to /fiscal_years/1" do
      route_for(:controller => "fiscal_years", :action => "update", :id => "1").should == {:path => "/fiscal_years/1", :method => :put}
    end

    it "should map { :controller => 'fiscal_years', :action => 'destroy', :id => 1} to /fiscal_years/1" do
      route_for(:controller => "fiscal_years", :action => "destroy", :id => "1").should == {:path => "/fiscal_years/1", :method => :delete}
    end
  end
end