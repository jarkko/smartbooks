require File.dirname(__FILE__) + '/../../spec_helper'

describe "/vat_reports/new.html.erb" do
  before(:each) do
    assigns[:fiscal_year] = mock_model(FiscalYear, :to_param => 69)
  end
  
  
  describe "when no month specified" do
    before(:each) do
      render "vat_reports/new"
    end
    
    it "should hava a get form to its own uri" do
      response.should have_tag("form[action=/fiscal_years/69/vat_reports/new][method=get]")
    end
    
    it "should show a dropdown for month selection" do
      response.should have_tag("select") do
        MONTHS.each do |month|
          with_tag("option", month.first)
        end
      end
    end
  end
  
  describe "when month specified" do
    before(:each) do
      @debt = mock_model(Account,
                         :description => "ALV-velka 22%")
      @debt.stub!(:formatted_total).with(:month => "11").and_return("+69.00")
      assigns[:debt] = @debt
      @receivables = mock_model(Account, :description => "Arvonlisäverosaamiset")
      @receivables.stub!(:formatted_total).with(:month => "11").and_return("+169.00")
      @receivables.stub!(:formatted_total).with(:month => 1..10).and_return("+2.00")
      assigns[:receivables] = @receivables
      params[:month] = "11"
      
      assigns[:fiscal_year].stub!(:payable_vat_for).with("11").and_return("+0.00")
      assigns[:fiscal_year].stub!(:transferred_vat_receivables_for).
                            with("11").and_return("+102.00")
      
      render "vat_reports/new"
    end
    
    it "should show the current month selected" do
      response.should have_tag("select") do
        with_tag("option[selected=selected]", "Marraskuu")
      end
    end
    
    it "should show amount of debt for the month" do
      response.should have_tag("td", "+69.00")
    end
    
    it "should show the deductibles for the month" do
      response.should have_tag("td", "+169.00")
    end
    
    it "should show pending receivables" do
      response.should have_tag("td", "+2.00")
    end
    
    it "should show payable vat" do
      response.should have_tag("th", "+0.00")
    end
    
    it "should show transferred receivables" do
      response.should have_tag("th", "+102.00")
    end
  end
end