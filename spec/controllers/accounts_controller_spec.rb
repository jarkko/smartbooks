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
    get :index, :format => "js"
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
#
#describe AccountsController, " handling GET /accounts.xml" do
#
#  before do
#    @account = mock_model(Account, :to_xml => "XML")
#    Account.stub!(:find).and_return(@account)
#  end
#  
#  def do_get
#    @request.env["HTTP_ACCEPT"] = "application/xml"
#    get :index
#  end
#  
#  it "should be successful" do
#    do_get
#    response.should be_success
#  end
#
#  it "should find all accounts" do
#    Account.should_receive(:find).with(:all).and_return([@account])
#    do_get
#  end
#  
#  it "should render the found accounts as xml" do
#    @account.should_receive(:to_xml).and_return("XML")
#    do_get
#    response.body.should == "XML"
#  end
#end

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

#describe AccountsController, " handling GET /accounts/new" do
#
#  before do
#    @account = mock_model(Account)
#    Account.stub!(:new).and_return(@account)
#  end
#  
#  def do_get
#    get :new
#  end
#
#  it "should be successful" do
#    do_get
#    response.should be_success
#  end
#  
#  it "should render new template" do
#    do_get
#    response.should render_template('new')
#  end
#  
#  it "should create an new account" do
#    Account.should_receive(:new).and_return(@account)
#    do_get
#  end
#  
#  it "should not save the new account" do
#    @account.should_not_receive(:save)
#    do_get
#  end
#  
#  it "should assign the new account for the view" do
#    do_get
#    assigns[:account].should equal(@account)
#  end
#end
#
#describe AccountsController, " handling GET /accounts/1/edit" do
#
#  before do
#    @account = mock_model(Account)
#    Account.stub!(:find).and_return(@account)
#  end
#  
#  def do_get
#    get :edit, :id => "1"
#  end
#
#  it "should be successful" do
#    do_get
#    response.should be_success
#  end
#  
#  it "should render edit template" do
#    do_get
#    response.should render_template('edit')
#  end
#  
#  it "should find the account requested" do
#    Account.should_receive(:find).and_return(@account)
#    do_get
#  end
#  
#  it "should assign the found Account for the view" do
#    do_get
#    assigns[:account].should equal(@account)
#  end
#end
#
#describe AccountsController, " handling POST /accounts" do
#
#  before do
#    @account = mock_model(Account, :to_param => "1", :save => true)
#    Account.stub!(:new).and_return(@account)
#    @params = {}
#  end
#  
#  def do_post
#    post :create, :account => @params
#  end
#  
#  it "should create a new account" do
#    Account.should_receive(:new).with(@params).and_return(@account)
#    do_post
#  end
#
#  it "should redirect to the new account" do
#    do_post
#    response.should redirect_to(account_url("1"))
#  end
#end
#
#describe AccountsController, " handling PUT /accounts/1" do
#
#  before do
#    @account = mock_model(Account, :to_param => "1", :update_attributes => true)
#    Account.stub!(:find).and_return(@account)
#  end
#  
#  def do_update
#    put :update, :id => "1"
#  end
#  
#  it "should find the account requested" do
#    Account.should_receive(:find).with("1").and_return(@account)
#    do_update
#  end
#
#  it "should update the found account" do
#    @account.should_receive(:update_attributes)
#    do_update
#    assigns(:account).should equal(@account)
#  end
#
#  it "should assign the found account for the view" do
#    do_update
#    assigns(:account).should equal(@account)
#  end
#
#  it "should redirect to the account" do
#    do_update
#    response.should redirect_to(account_url("1"))
#  end
#end
#
#describe AccountsController, " handling DELETE /accounts/1" do
#
#  before do
#    @account = mock_model(Account, :destroy => true)
#    Account.stub!(:find).and_return(@account)
#  end
#  
#  def do_delete
#    delete :destroy, :id => "1"
#  end
#
#  it "should find the account requested" do
#    Account.should_receive(:find).with("1").and_return(@account)
#    do_delete
#  end
#  
#  it "should call destroy on the found account" do
#    @account.should_receive(:destroy)
#    do_delete
#  end
#  
#  it "should redirect to the accounts list" do
#    do_delete
#    response.should redirect_to(accounts_url)
#  end
#end