require File.dirname(__FILE__) + '/../spec_helper'

#describe EventLinesController, "#route_for" do
#
#  it "should map { :controller => 'event_lines', :action => 'index' } to /event_lines" do
#    route_for(:controller => "event_lines", :action => "index").should == "/event_lines"
#  end
#  
#  it "should map { :controller => 'event_lines', :action => 'new' } to /event_lines/new" do
#    route_for(:controller => "event_lines", :action => "new").should == "/event_lines/new"
#  end
#  
#  it "should map { :controller => 'event_lines', :action => 'show', :id => 1 } to /event_lines/1" do
#    route_for(:controller => "event_lines", :action => "show", :id => 1).should == "/event_lines/1"
#  end
#  
#  it "should map { :controller => 'event_lines', :action => 'edit', :id => 1 } to /event_lines/1;edit" do
#    route_for(:controller => "event_lines", :action => "edit", :id => 1).should == "/event_lines/1;edit"
#  end
#  
#  it "should map { :controller => 'event_lines', :action => 'update', :id => 1} to /event_lines/1" do
#    route_for(:controller => "event_lines", :action => "update", :id => 1).should == "/event_lines/1"
#  end
#  
#  it "should map { :controller => 'event_lines', :action => 'destroy', :id => 1} to /event_lines/1" do
#    route_for(:controller => "event_lines", :action => "destroy", :id => 1).should == "/event_lines/1"
#  end
#  
#end
#
#describe EventLinesController, " handling GET /event_lines" do
#
#  before do
#    @event_line = mock_model(EventLine)
#    EventLine.stub!(:find).and_return([@event_line])
#  end
#  
#  def do_get
#    get :index
#  end
#  
#  it "should be successful" do
#    do_get
#    response.should be_success
#  end
#
#  it "should render index template" do
#    do_get
#    response.should render_template('index')
#  end
#  
#  it "should find all event_lines" do
#    EventLine.should_receive(:find).with(:all).and_return([@event_line])
#    do_get
#  end
#  
#  it "should assign the found event_lines for the view" do
#    do_get
#    assigns[:event_lines].should == [@event_line]
#  end
#end
#
#describe EventLinesController, " handling GET /event_lines.xml" do
#
#  before do
#    @event_line = mock_model(EventLine, :to_xml => "XML")
#    EventLine.stub!(:find).and_return(@event_line)
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
#  it "should find all event_lines" do
#    EventLine.should_receive(:find).with(:all).and_return([@event_line])
#    do_get
#  end
#  
#  it "should render the found event_lines as xml" do
#    @event_line.should_receive(:to_xml).and_return("XML")
#    do_get
#    response.body.should == "XML"
#  end
#end
#
#describe EventLinesController, " handling GET /event_lines/1" do
#
#  before do
#    @event_line = mock_model(EventLine)
#    EventLine.stub!(:find).and_return(@event_line)
#  end
#  
#  def do_get
#    get :show, :id => "1"
#  end
#
#  it "should be successful" do
#    do_get
#    response.should be_success
#  end
#  
#  it "should render show template" do
#    do_get
#    response.should render_template('show')
#  end
#  
#  it "should find the event_line requested" do
#    EventLine.should_receive(:find).with("1").and_return(@event_line)
#    do_get
#  end
#  
#  it "should assign the found event_line for the view" do
#    do_get
#    assigns[:event_line].should equal(@event_line)
#  end
#end
#
#describe EventLinesController, " handling GET /event_lines/1.xml" do
#
#  before do
#    @event_line = mock_model(EventLine, :to_xml => "XML")
#    EventLine.stub!(:find).and_return(@event_line)
#  end
#  
#  def do_get
#    @request.env["HTTP_ACCEPT"] = "application/xml"
#    get :show, :id => "1"
#  end
#
#  it "should be successful" do
#    do_get
#    response.should be_success
#  end
#  
#  it "should find the event_line requested" do
#    EventLine.should_receive(:find).with("1").and_return(@event_line)
#    do_get
#  end
#  
#  it "should render the found event_line as xml" do
#    @event_line.should_receive(:to_xml).and_return("XML")
#    do_get
#    response.body.should == "XML"
#  end
#end
#
#describe EventLinesController, " handling GET /event_lines/new" do
#
#  before do
#    @event_line = mock_model(EventLine)
#    EventLine.stub!(:new).and_return(@event_line)
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
#  it "should create an new event_line" do
#    EventLine.should_receive(:new).and_return(@event_line)
#    do_get
#  end
#  
#  it "should not save the new event_line" do
#    @event_line.should_not_receive(:save)
#    do_get
#  end
#  
#  it "should assign the new event_line for the view" do
#    do_get
#    assigns[:event_line].should equal(@event_line)
#  end
#end
#
#describe EventLinesController, " handling GET /event_lines/1/edit" do
#
#  before do
#    @event_line = mock_model(EventLine)
#    EventLine.stub!(:find).and_return(@event_line)
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
#  it "should find the event_line requested" do
#    EventLine.should_receive(:find).and_return(@event_line)
#    do_get
#  end
#  
#  it "should assign the found EventLine for the view" do
#    do_get
#    assigns[:event_line].should equal(@event_line)
#  end
#end
#
#describe EventLinesController, " handling POST /event_lines" do
#
#  before do
#    @event_line = mock_model(EventLine, :to_param => "1", :save => true)
#    EventLine.stub!(:new).and_return(@event_line)
#    @params = {}
#  end
#  
#  def do_post
#    post :create, :event_line => @params
#  end
#  
#  it "should create a new event_line" do
#    EventLine.should_receive(:new).with(@params).and_return(@event_line)
#    do_post
#  end
#
#  it "should redirect to the new event_line" do
#    do_post
#    response.should redirect_to(event_line_url("1"))
#  end
#end
#
#describe EventLinesController, " handling PUT /event_lines/1" do
#
#  before do
#    @event_line = mock_model(EventLine, :to_param => "1", :update_attributes => true)
#    EventLine.stub!(:find).and_return(@event_line)
#  end
#  
#  def do_update
#    put :update, :id => "1"
#  end
#  
#  it "should find the event_line requested" do
#    EventLine.should_receive(:find).with("1").and_return(@event_line)
#    do_update
#  end
#
#  it "should update the found event_line" do
#    @event_line.should_receive(:update_attributes)
#    do_update
#    assigns(:event_line).should equal(@event_line)
#  end
#
#  it "should assign the found event_line for the view" do
#    do_update
#    assigns(:event_line).should equal(@event_line)
#  end
#
#  it "should redirect to the event_line" do
#    do_update
#    response.should redirect_to(event_line_url("1"))
#  end
#end
#
#describe EventLinesController, " handling DELETE /event_lines/1" do
#
#  before do
#    @event_line = mock_model(EventLine, :destroy => true)
#    EventLine.stub!(:find).and_return(@event_line)
#  end
#  
#  def do_delete
#    delete :destroy, :id => "1"
#  end
#
#  it "should find the event_line requested" do
#    EventLine.should_receive(:find).with("1").and_return(@event_line)
#    do_delete
#  end
#  
#  it "should call destroy on the found event_line" do
#    @event_line.should_receive(:destroy)
#    do_delete
#  end
#  
#  it "should redirect to the event_lines list" do
#    do_delete
#    response.should redirect_to(event_lines_url)
#  end
#end