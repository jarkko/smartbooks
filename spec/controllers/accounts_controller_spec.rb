require File.dirname(__FILE__) + '/../spec_helper'

describe AccountsController, "#route_for" do

  it "should map { :controller => 'accounts', :action => 'index' } to /accounts" do
    route_for(:controller => "accounts", :action => "index").should == "/accounts"
  end
  
  it "should map { :controller => 'accounts', :action => 'new' } to /accounts/new" do
    route_for(:controller => "accounts", :action => "new").should == "/accounts/new"
  end
  
  it "should map { :controller => 'accounts', :action => 'show', :id => 1 } to /accounts/1" do
    route_for(:controller => "accounts", :action => "show", :id => 1).should == "/accounts/1"
  end
  
  it "should map { :controller => 'accounts', :action => 'edit', :id => 1 } to /accounts/1;edit" do
    route_for(:controller => "accounts", :action => "edit", :id => 1).should == "/accounts/1/edit"
  end
  
  it "should map { :controller => 'accounts', :action => 'update', :id => 1} to /accounts/1" do
    route_for(:controller => "accounts", :action => "update", :id => 1).should == "/accounts/1"
  end
  
  it "should map { :controller => 'accounts', :action => 'destroy', :id => 1} to /accounts/1" do
    route_for(:controller => "accounts", :action => "destroy", :id => 1).should == "/accounts/1"
  end
  
end

describe AccountsController, " handling GET /accounts" do

  before do
    @account = mock_model(Account)
    Account.stub!(:find).and_return([@account])
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
  
  it "should find all accounts" do
    Account.should_receive(:find).with(:all).and_return([@account])
    do_get
  end
  
  it "should assign the found accounts for the view" do
    do_get
    assigns[:accounts].should == [@account]
  end
end

describe AccountsController, " handling GET /accounts.xml" do

  before do
    @account = mock_model(Account, :to_xml => "XML")
    Account.stub!(:find).and_return(@account)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should find all accounts" do
    Account.should_receive(:find).with(:all).and_return([@account])
    do_get
  end
  
  it "should render the found accounts as xml" do
    @account.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe AccountsController, " handling GET /accounts/1" do

  before do
    @account = mock_model(Account)
    Account.stub!(:find).and_return(@account)
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
  
  it "should find the account requested" do
    Account.should_receive(:find).with("1", :include => [:event_lines => :event]).and_return(@account)
    do_get
  end
  
  it "should assign the found account for the view" do
    do_get
    assigns[:account].should equal(@account)
  end
end

describe AccountsController, " handling GET /accounts/new" do

  before do
    @account = mock_model(Account)
    Account.stub!(:new).and_return(@account)
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
  
  it "should create an new account" do
    Account.should_receive(:new).and_return(@account)
    do_get
  end
  
  it "should not save the new account" do
    @account.should_not_receive(:save)
    do_get
  end
  
  it "should assign the new account for the view" do
    do_get
    assigns[:account].should equal(@account)
  end
end

describe AccountsController, " handling GET /accounts/1/edit" do

  before do
    @account = mock_model(Account)
    Account.stub!(:find).and_return(@account)
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
  
  it "should find the account requested" do
    Account.should_receive(:find).and_return(@account)
    do_get
  end
  
  it "should assign the found Account for the view" do
    do_get
    assigns[:account].should equal(@account)
  end
end

describe AccountsController, " handling POST /accounts" do

  before do
    @account = mock_model(Account, :to_param => "1", :save => true)
    Account.stub!(:new).and_return(@account)
    @params = {}
  end
  
  def do_post
    post :create, :account => @params
  end
  
  it "should create a new account" do
    Account.should_receive(:new).with(@params).and_return(@account)
    do_post
  end

  it "should redirect to the new account" do
    do_post
    response.should redirect_to(account_url("1"))
  end
end

describe AccountsController, " handling PUT /accounts/1" do

  before do
    @account = mock_model(Account, :to_param => "1", :update_attributes => true)
    Account.stub!(:find).and_return(@account)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  it "should find the account requested" do
    Account.should_receive(:find).with("1").and_return(@account)
    do_update
  end

  it "should update the found account" do
    @account.should_receive(:update_attributes)
    do_update
    assigns(:account).should equal(@account)
  end

  it "should assign the found account for the view" do
    do_update
    assigns(:account).should equal(@account)
  end

  it "should redirect to the account" do
    do_update
    response.should redirect_to(account_url("1"))
  end
end

describe AccountsController, " handling DELETE /accounts/1" do

  before do
    @account = mock_model(Account, :destroy => true)
    Account.stub!(:find).and_return(@account)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  it "should find the account requested" do
    Account.should_receive(:find).with("1").and_return(@account)
    do_delete
  end
  
  it "should call destroy on the found account" do
    @account.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the accounts list" do
    do_delete
    response.should redirect_to(accounts_url)
  end
end