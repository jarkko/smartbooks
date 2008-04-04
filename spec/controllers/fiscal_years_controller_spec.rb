require File.dirname(__FILE__) + '/../spec_helper'

describe FiscalYearsController, "#route_for" do

  it "should map { :controller => 'fiscal_years', :action => 'index' } to /fiscal_years" do
    route_for(:controller => "fiscal_years", :action => "index").should == "/fiscal_years"
  end
  
  it "should map { :controller => 'fiscal_years', :action => 'new' } to /fiscal_years/new" do
    route_for(:controller => "fiscal_years", :action => "new").should == "/fiscal_years/new"
  end
  
  it "should map { :controller => 'fiscal_years', :action => 'show', :id => 1 } to /fiscal_years/1" do
    route_for(:controller => "fiscal_years", :action => "show", :id => 1).should == "/fiscal_years/1"
  end
  
  it "should map { :controller => 'fiscal_years', :action => 'edit', :id => 1 } to /fiscal_years/1;edit" do
    route_for(:controller => "fiscal_years", :action => "edit", :id => 1).should == "/fiscal_years/1/edit"
  end
  
  it "should map { :controller => 'fiscal_years', :action => 'update', :id => 1} to /fiscal_years/1" do
    route_for(:controller => "fiscal_years", :action => "update", :id => 1).should == "/fiscal_years/1"
  end
  
  it "should map { :controller => 'fiscal_years', :action => 'destroy', :id => 1} to /fiscal_years/1" do
    route_for(:controller => "fiscal_years", :action => "destroy", :id => 1).should == "/fiscal_years/1"
  end
  
end

describe FiscalYearsController, " handling GET /fiscal_years" do

  before do
    @fiscal_year = mock_model(FiscalYear)
    FiscalYear.stub!(:find).and_return([@fiscal_year])
  end
  
  def do_get
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should render index template" do
    do_get
    response.should render_template('index')
  end
  
  it "should find all fiscal_years" do
    FiscalYear.should_receive(:find).with(:all).and_return([@fiscal_year])
    do_get
  end
  
  it "should assign the found fiscal_years for the view" do
    do_get
    assigns[:fiscal_years].should == [@fiscal_year]
  end
end

describe FiscalYearsController, " handling GET /fiscal_years.xml" do

  before do
    @fiscal_year = mock_model(FiscalYear, :to_xml => "XML")
    FiscalYear.stub!(:find).and_return(@fiscal_year)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should find all fiscal_years" do
    FiscalYear.should_receive(:find).with(:all).and_return([@fiscal_year])
    do_get
  end
  
  it "should render the found fiscal_years as xml" do
    @fiscal_year.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe FiscalYearsController, " handling GET /fiscal_years/1" do

  before do
    @fiscal_year = mock_model(FiscalYear)
    FiscalYear.stub!(:find).and_return(@fiscal_year)
  end
  
  def do_get
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render show template" do
    do_get
    response.should render_template('show')
  end
  
  it "should find the fiscal_year requested" do
    FiscalYear.should_receive(:find).with("1").and_return(@fiscal_year)
    do_get
  end
  
  it "should assign the found fiscal_year for the view" do
    do_get
    assigns[:fiscal_year].should equal(@fiscal_year)
  end
end

describe FiscalYearsController, " handling GET /fiscal_years/1.xml" do

  before do
    @fiscal_year = mock_model(FiscalYear, :to_xml => "XML")
    FiscalYear.stub!(:find).and_return(@fiscal_year)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should find the fiscal_year requested" do
    FiscalYear.should_receive(:find).with("1").and_return(@fiscal_year)
    do_get
  end
  
  it "should render the found fiscal_year as xml" do
    @fiscal_year.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe FiscalYearsController, " handling GET /fiscal_years/new" do

  before do
    @fiscal_year = mock_model(FiscalYear)
    FiscalYear.stub!(:new).and_return(@fiscal_year)
  end
  
  def do_get
    get :new
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render new template" do
    do_get
    response.should render_template('new')
  end
  
  it "should create an new fiscal_year" do
    FiscalYear.should_receive(:new).and_return(@fiscal_year)
    do_get
  end
  
  it "should not save the new fiscal_year" do
    @fiscal_year.should_not_receive(:save)
    do_get
  end
  
  it "should assign the new fiscal_year for the view" do
    do_get
    assigns[:fiscal_year].should equal(@fiscal_year)
  end
end

describe FiscalYearsController, " handling GET /fiscal_years/1/edit" do

  before do
    @fiscal_year = mock_model(FiscalYear)
    FiscalYear.stub!(:find).and_return(@fiscal_year)
  end
  
  def do_get
    get :edit, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render edit template" do
    do_get
    response.should render_template('edit')
  end
  
  it "should find the fiscal_year requested" do
    FiscalYear.should_receive(:find).and_return(@fiscal_year)
    do_get
  end
  
  it "should assign the found FiscalYear for the view" do
    do_get
    assigns[:fiscal_year].should equal(@fiscal_year)
  end
end

describe FiscalYearsController, " handling POST /fiscal_years" do

  before do
    @fiscal_year = mock_model(FiscalYear, :to_param => "1", :save => true)
    FiscalYear.stub!(:new).and_return(@fiscal_year)
    @params = {}
  end
  
  def do_post
    post :create, :fiscal_year => @params
  end
  
  it "should create a new fiscal_year" do
    FiscalYear.should_receive(:new).with(@params).and_return(@fiscal_year)
    do_post
  end

  it "should redirect to the new fiscal_year" do
    do_post
    response.should redirect_to(fiscal_year_url("1"))
  end
end

describe FiscalYearsController, " handling PUT /fiscal_years/1" do

  before do
    @fiscal_year = mock_model(FiscalYear, :to_param => "1", :update_attributes => true)
    FiscalYear.stub!(:find).and_return(@fiscal_year)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  it "should find the fiscal_year requested" do
    FiscalYear.should_receive(:find).with("1").and_return(@fiscal_year)
    do_update
  end

  it "should update the found fiscal_year" do
    @fiscal_year.should_receive(:update_attributes)
    do_update
    assigns(:fiscal_year).should equal(@fiscal_year)
  end

  it "should assign the found fiscal_year for the view" do
    do_update
    assigns(:fiscal_year).should equal(@fiscal_year)
  end

  it "should redirect to the fiscal_year" do
    do_update
    response.should redirect_to(fiscal_year_url("1"))
  end
end

describe FiscalYearsController, " handling DELETE /fiscal_years/1" do

  before do
    @fiscal_year = mock_model(FiscalYear, :destroy => true)
    FiscalYear.stub!(:find).and_return(@fiscal_year)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  it "should find the fiscal_year requested" do
    FiscalYear.should_receive(:find).with("1").and_return(@fiscal_year)
    do_delete
  end
  
  it "should call destroy on the found fiscal_year" do
    @fiscal_year.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the fiscal_years list" do
    do_delete
    response.should redirect_to(fiscal_years_url)
  end
end