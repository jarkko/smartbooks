# -*- encoding : utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FiscalYearsController do
  describe "#route_for" do
    it "should map { :controller => 'fiscal_years', :action => 'index' } to /fiscal_years" do
      { :get => "/fiscal_years" }.should route_to(
        :controller => "fiscal_years", :action => "index"
      )
    end

    it "should map { :controller => 'fiscal_years', :action => 'new' } to /fiscal_years/new" do
      { :get => "/fiscal_years/new" }.should route_to(
        :controller => "fiscal_years", :action => "new"
      )
    end

    it "should map { :controller => 'fiscal_years', :action => 'show', :id => 1 } to /fiscal_years/1" do
      { :get => "/fiscal_years/1" }.should route_to(
        :controller => "fiscal_years", :action => "show", :id => "1"
      )
    end

    it "should map { :controller => 'fiscal_years', :action => 'edit', :id => 1 } to /fiscal_years/1;edit" do
      { :get => "/fiscal_years/1/edit" }.should route_to(
        :controller => "fiscal_years", :action => "edit", :id => "1"
      )
    end

    it "should map { :controller => 'fiscal_years', :action => 'update', :id => 1} to /fiscal_years/1" do
      { :put => "/fiscal_years/1" }.should route_to(
        :controller => "fiscal_years", :action => "update", :id => "1"
      )
    end

    it "should map { :controller => 'fiscal_years', :action => 'destroy', :id => 1} to /fiscal_years/1" do
      { :delete => "/fiscal_years/1" }.should route_to(
        :controller => "fiscal_years", :action => "destroy", :id => "1"
      )
    end
  end
end
