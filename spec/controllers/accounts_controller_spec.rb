require File.dirname(__FILE__) + '/../spec_helper'

describe AccountsController, " handling GET /accounts.js" do

  before do
    @account = stub_model(Account)
    @accounts = [@account]
    @fiscal_year = stub_model(FiscalYear, :account => @accounts)
    FiscalYear.stub!(:find).and_return(@fiscal_year)
    @fiscal_year.accounts.stub!(:find_for_dropdown).and_return(@accounts) 
  end
  
  def do_get
    get :index, :fiscal_year_id => @fiscal_year.id, :format => "js"
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should assign accounts correctly" do
    do_get
    assigns[:accounts].should == @accounts
  end

  it "should render accounts as json" do
    do_get
    response.should have_text("var accounts = " + @accounts.to_json(:only => [:title, :id]))
  end
end

describe AccountsController, " handling GET /accounts/1" do

  before do
    @account = mock_model(Account)
    
    @fy = mock_model(FiscalYear)
    @accounts = [@account]
    @accounts.stub!(:find).and_return(@account)
    @fy.stub!(:accounts).and_return(@accounts)
    FiscalYear.stub!(:find).and_return(@fy)
  end
  
  def do_get
    get :show, :id => "1", :fiscal_year_id => "6"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render show template" do
    do_get
    response.should render_template('show')
  end
  
  it "should find the fiscal year" do
    FiscalYear.should_receive(:find).with("6").and_return(@fy)
    do_get
  end
  
  it "should find the account requested" do
    @accounts.should_receive(:find).with("1", :include => [:event_lines => :event]).and_return(@account)
    do_get
  end
  
  it "should assign the found account for the view" do
    do_get
    assigns[:account].should equal(@account)
  end
end