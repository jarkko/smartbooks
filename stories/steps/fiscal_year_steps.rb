steps_for(:fiscal_year) do
  Given "an empty database" do
    [EventLine, Account, Event, FiscalYear].each do |klass|
      klass.delete_all
    end
    @fiscal_year_count = 0
  end
  
  Given "a fiscal year with existing accounts" do
    @existing_fiscal_year = FiscalYear.create!(
                                :description => "2007",
                                :start_date => "2007-01-01",
                                :end_date => "2007-12-31")
                                
    @fiscal_year_count += 1
                                
    5.times do |i|
      @existing_fiscal_year.accounts << Account.create!(
                                          :title => "account_#{i}",
                                          :account_number => "#{i}")      
    end
  end
  
  When "user loads the new fiscal year form" do
    visits "fiscal_years/new"
  end
  
  When "fills in fiscal year details" do
    fills_in "Description", :with => "2008"
    fills_in "Start date", :with => "2008-01-01"
    fills_in "End date", :with => "2008-12-31"
  end
  
  When "clicks '$button'" do |button|
    clicks_button button
  end
  
  When "selects to copy accounts from the existing fiscal year" do
    selects "2007"
  end
  
  Then "a new fiscal year should be created" do
    FiscalYear.count.should == @fiscal_year_count + 1
    @fiscal_year = FiscalYear.find(:first, :order => "id desc")
    @fiscal_year.description.should == "2008"
    @fiscal_year.start_date.to_s.should == "2008-01-01"
    @fiscal_year.end_date.to_s.should == "2008-12-31"
  end
  
  Then "the user should be shown a message that the fiscal year was created" do
    response.body.should match(/Fiscal year was successfully created/)
  end
  
  Then "the new fiscal year should have no accounts" do
    @fiscal_year.accounts.should be_empty
  end
  
  Then "the new fiscal year should have similar accounts as the existing year" do
    @fiscal_year.accounts.count.should == @existing_fiscal_year.accounts.count
    @fiscal_year.accounts.map(&:title).should == @existing_fiscal_year.accounts.map(&:title)
  end
end