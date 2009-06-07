require File.dirname(__FILE__) + '/../spec_helper'

describe FiscalYearsController do
  before(:all) do
    @fiscal_years = [mock_fiscal_year, mock_fiscal_year]
  end
  
  describe "GET new" do
    before(:each) do
      @fiscal_year = mock_fiscal_year
      FiscalYear.stub!(:new).and_return(@fiscal_year)
      FiscalYear.stub!(:find).with(:all).and_return(@fiscal_years)
      
      get :new
    end
    
    it "should assign fiscal year" do
      assigns[:fiscal_year].should == @fiscal_year
    end
    
    it "should assign other fiscal years for the dropdown" do
      assigns[:fiscal_years].should == @fiscal_years
    end
  end
  
  describe "GET index" do
    before(:each) do
      FiscalYear.should_receive(:find).with(:all).and_return(@fiscal_years)
      get :index
    end
        
    it "should be successful" do
      response.should be_success
      response.should render_template('fiscal_years/index')
    end
    
    it "should fetch all fiscal years" do
      assigns[:fiscal_years].should == @fiscal_years
    end
  end
  
  describe "POST create" do
    before(:each) do
      @post_params = {:fiscal_year => {"description" => "2008",
                                       "start_date" => "2008-01-01",
                                       "end_date" => "2008-12-31"}}
      @fiscal_year = mock_fiscal_year  
      FiscalYear.stub!(:create).and_return(@fiscal_year)                                    
    end
    
    def post_create
      post :create, @post_params
    end
    
    it "should create new fiscal year" do
      FiscalYear.should_receive(:create).with(@post_params[:fiscal_year])
      post_create
    end
    
    it "should redirect to the events page of the fiscal year" do
      post_create
      response.should redirect_to(fiscal_year_events_url(@fiscal_year))
    end
    
    it "should set the flash message correctly" do
      post_create
      flash[:notice].should == "Fiscal year was successfully created"
    end
  end
end


