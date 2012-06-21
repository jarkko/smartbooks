# -*- encoding : utf-8 -*-
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
    
    @assets = @existing_fiscal_year.accounts.create!(
                                          :title => "Vastaavaa",
                                          :account_number => "-1")
                                          
                                      
    @existing_fiscal_year.accounts.create!(
        :title => "Vaihtuvat vastaavat",
        :account_number => "-1",
        :parent => @assets)
                                              
    @liabilities = @existing_fiscal_year.accounts.create(
                                          :title => "Vastattavaa",
                                          :account_number => "-1")
    
    @equity = @existing_fiscal_year.accounts.create(
                                          :title => "OMA PÄÄOMA",
                                          :account_number => "990",
                                          :parent => @liabilities)
    
    @private_equity = @existing_fiscal_year.accounts.create(
                                 :title => "Yksityistilit tilikaudella",
                                 :account_number => "991",
                                 :parent => @equity)
                                  
    @stockholders_equity = @existing_fiscal_year.accounts.create(
                                 :title => "Oma pääoma (tilinavaus)",
                                 :account_number => "997",
                                 :parent => @equity)
                                
    5.times do |i|
      account = Account.create!(
                    :title => "account_#{i}",
                    :account_number => "#{i}",
                    :parent_id => (rand(10) % 2 ? @assets.id : @liabilities.id))
      @existing_fiscal_year.accounts << account
    end
    
    10.times do |i|
      event = @existing_fiscal_year.events.build(
                        :event_date => Date.today,
                        :description => "Event #{i}",
                        :receipt_number => "000#{i}")
      amount = rand(10000)
      real_accounts = @existing_fiscal_year.accounts - Account.find_virtual
      event.event_lines.build(
          {:amount => amount, 
           :account => real_accounts.rand})
           
      debit_account = i == 3 ? @stockholders_equity : real_accounts.rand
      
      event.event_lines.build(
          {:amount => (-1 * amount), 
           :account => debit_account})
      event.save!
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
  
  When "chooses to copy the balance of the balance sheet accounts" do
    checks "Copy the balance sheet balance"
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
    @fiscal_year.accounts.count.should ==
      @existing_fiscal_year.accounts.count
    @fiscal_year.accounts.map(&:title).sort.should ==
      @existing_fiscal_year.accounts.map(&:title).sort
    
    @fiscal_year.assets.children.should_not be_empty  
    @fiscal_year.assets.children.map(&:title).should ==
      @existing_fiscal_year.assets.children.map(&:title)
  end
  
  Then "the balance sheet accounts should have equal balance with the corresponding accounts in the previous year, except for the equity accounts" do    
    [:assets, :liabilities].each do |balance_sheet_account|
      @fiscal_year.send(balance_sheet_account).all_children.each do |account|
        next if account == @fiscal_year.stockholders_equity
        account.total.should == (@fiscal_year.equity.all_children.include?(account) ? 0 : 
                                         @existing_fiscal_year.accounts.
                                          find_by_account_number(account.account_number).total)
      end
    end 
  end
end
