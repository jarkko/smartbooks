require File.dirname(__FILE__) + '/../spec_helper'

describe FiscalYear do
  before(:each) do
    @fiscal_year = FiscalYear.new(:start_date => Date.new(2008,1,1),
                                  :end_date => Date.new(2008,12,31),
                                  :description => "2008")

    FiscalYear.account_names.each do |key, name|
      instance_variable_set("@#{key}", mock_model(Account, :title => name))
      @fiscal_year.accounts.
        stub!(:find_by_title).with(name).and_return(instance_variable_get("@#{key}"))
    end

    @vat_debt.stub!(:total).with(:month => 11).and_return(-60000)
    @vat_receivables.stub!(:total).with(:month => 1..11).and_return(50000)
  end

  it "should be valid" do
     @fiscal_year.should be_valid
  end
  
  FiscalYear.account_names.each do |key, name|
    describe "#{key}" do
      it "calling #{key} should return account '#{name}'" do
        @fiscal_year.send(key).should == instance_variable_get("@#{key}")
      end
    end
  end
  
  describe "creation" do
    before(:each) do
      @fiscal_year.connection.stub!(:insert).and_return(96)
      @fiscal_year.connection.stub!(:update_sql).and_return(96)
      
      
      @fy2 = mock_fiscal_year
      @root_accounts = @fy2.accounts - @bank_accounts.children -
                       @sales.children
      @fy2.accounts.stub!(:find_all_by_parent_id).
            and_return(@root_accounts)
      FiscalYear.stub!(:find).with("69").and_return(@fy2)
    end
    
    describe "when copy_accounts_from set" do
      before(:each) do
        @fiscal_year.copy_accounts_from = "69"
      end
      
      it "should set the accounts to equal the ones of the source" do
        #puts "\nFY\n" + @fiscal_year.accounts.map{|a| [a.id, a.title]}.inspect
        #puts "\nFY2\n" + @fy2.accounts.map{|a| [a.id, a.title]}.inspect
        @fiscal_year.save
        #puts @fiscal_year.accounts.map{|a| [a.id, a.title]}.inspect
        @fiscal_year.accounts.map(&:title).sort.should ==
          @fy2.accounts.map(&:title).sort
      end
      
      it "should rebuild the account hierarchy" do
        @fiscal_year.save
        @fiscal_year.accounts.
          detect do |account| 
            account.title == "Pankkisaamiset"
          end.children.map(&:title).should ==
              @fy2.bank_accounts.children.map(&:title)
      end
      
      describe "and copy_balance set" do
        before(:each) do
          @fiscal_year.copy_balance = "1"
          @fiscal_year.accounts.stub!(:select).and_return([@assets, @liabilities])
          @fiscal_year.accounts.stub!(:detect).and_return(:equity)
          @assets.stub!(:all_children).
                and_return([@vat_receivables, @current_assets])
          @liabilities.stub!(:all_children).
                and_return([@vat_payable, @accounts_payable, @stockholders_equity, @private_equity])
          
          @equity = @fiscal_year.equity
          @equity.stub!(:all_children).and_return([@stockholders_equity, @private_equity])      
          @children = @liabilities.all_children + @assets.all_children - @equity.all_children
          @children.each do |child|
            child.stub!(:open_account_from)
          end
        end
        
        it "should open the balance sheet accounts with the balance from the previous year" do
          @children.each do |child|
            original = @fy2.accounts.detect{|acc| acc.account_number == child.account_number}
            child.should_receive(:open_account_from).with(original)
          end
          @fiscal_year.save
        end
        
        it "should not open account for equity accounts" do
          @equity.all_children.each do |child|
            child.should_not_receive(:open_account_from)
          end
          
          @fiscal_year.save
        end
      end
    end
    
    describe "when copy_accounts_from blank" do
      before(:each) do
        @fiscal_year.copy_accounts_from = ""
      end
      
      it "should not copy accounts" do
        @fiscal_year.should_not_receive(:copy_accounts)
        @fiscal_year.save
      end
    end
  end
  
  describe "total_income" do
    before(:each) do
      @sales.stub!(:result).and_return(6900)
      @interest_income.stub!(:result).and_return(1200)
    end
    
    it "should return sales + interest income" do
      @fiscal_year.total_income.should == 8100
    end
  end
  
  describe "total_expenses" do
    before(:each) do
      [@purchases, @services, @depreciation, @other_expenses, @interest_expenses].each do |account|
        account.stub!(:result).and_return(10)
      end
    end

    it "should return the sum of all expenses" do
      @fiscal_year.total_expenses.should == 50
    end
  end
  
  describe "net_income_before_taxes" do
    before(:each) do
      @fiscal_year.stub!(:total_income).and_return(-10000)
      @fiscal_year.stub!(:total_expenses).and_return(5000)
    end
    
    it "should return total income - total expenses" do
      @fiscal_year.net_income_before_taxes.should == 5000
    end
  end
  
  describe "net_operating_income" do
    before(:each) do
      @fiscal_year.stub!(:net_income_before_taxes).and_return(5000)
      @fiscal_year.stub!(:interest_income).and_return(@interest_income)
      @interest_income.stub!(:result).and_return(-100)
    end
    
    it "should return net income before taxes - interest income" do
      @fiscal_year.net_operating_income.should == 4900
    end
  end
  
  describe "net_income" do
    before(:each) do
      @fiscal_year.stub!(:net_income_before_taxes).and_return(5000)
      @fiscal_year.stub!(:taxes).and_return(@taxes)
      @taxes.stub!(:result).and_return(500)
    end
    
    it "should return net income before taxes - taxes" do
      @fiscal_year.net_income.should == 4500
    end
  end
  
  describe "payable_vat_for" do
    describe "when payables greater than deductions" do
      it "should return the formatted sum" do
        @fiscal_year.payable_vat_for("11").should == "100.00"
      end
    end
    
    describe "when deductions greater than payables" do
      before(:each) do
        @vat_receivables.stub!(:total).with(:month => 1..11).and_return(70000)
      end
      
      it "should return zero" do
        @fiscal_year.payable_vat_for("11").should == "0.00"
      end
    end
  end
  
  describe "transferred_vat_receivables_for" do    
    describe "when payables greater than deductions" do
      it "should return zero" do
        @fiscal_year.transferred_vat_receivables_for("11").should == "0.00"
      end
    end
    
    describe "when deductions greater than payables" do
      before(:each) do
        @vat_receivables.stub!(:total).with(:month => 1..11).and_return(70000)
      end
      
      it "should return the actual amount" do
        @fiscal_year.transferred_vat_receivables_for("11").should == "100.00"
      end
    end
  end
  
  describe "private_equity" do    
    describe "when investments > withdraws" do
      before(:each) do
        @private_equity.stub!(:result).and_return(-63000)
      end
      
      it "should return positive balance" do
        @fiscal_year.private_equity_result.should == 63000
      end
    end
    
    describe "when investments < withdraws" do
      before(:each) do
        @private_equity.stub!(:result).and_return(63000)
      end
      
      it "should return positive balance" do
        @fiscal_year.private_equity_result.should == -63000
      end
    end
  end
  
  describe "liabilities" do
    before(:each) do
      @stockholders_equity.stub!(:result).and_return(-900000)
      @private_equity.stub!(:result).and_return(-3700000)
      @fiscal_year.stub!(:net_income).and_return(2490000)
      @current_liabilities.stub!(:result).and_return(-480000)
    end
    
    it "should return stockholder's equity + private equity + net income/loss +
        short term liabilities" do
      @fiscal_year.liabilities_result.should == 
          (@fiscal_year.stockholders_equity.result.abs +
           @fiscal_year.private_equity_result +
           @fiscal_year.net_income +
           @fiscal_year.current_liabilities.result.abs)
    end
  end
  
  describe "event creation" do
    before(:each) do
      @event = mock_model(Event, :event_lines => [],
                                 :save! => true)

      @event.event_lines.stub!(:build)
      @lines = {
        "1" => {"debit" => "", "account_id" => "380", "credit" => "60"}, 
        "2" => {"debit" => "50", "account_id" => "398", "credit" => ""},
        "3" => {"debit" => "10", "account_id" => "359", "credit" => ""},
        "4" => {"debit" => "", "account_id" => "357", "credit" => ""},
        "5" => {:amount => "25000", :account_id => "398"}}

      @fiscal_year.events.stub!(:build).and_return(@event)
    end
    
    describe "create_event" do
      before(:each) do
        @fiscal_year.stub!(:build_event).and_return(@event)
      end
      
      it "should delegate to build_event" do
        @fiscal_year.should_receive(:build_event).with(@event, @lines).
          and_return(@event)
        @fiscal_year.create_event(@event, @lines)
      end
      
      it "should return the event" do
        @fiscal_year.create_event(@event, @lines).should == @event
      end
    end
    
    describe "build_event" do
      it "should build new Event" do
        @fiscal_year.events.should_receive(:build).
            with(@event).and_return(@event)
        @fiscal_year.build_event(@event, @lines)
      end

      it "should add event lines to the event" do
        (@lines.keys - ["4"]).each do |line|
          @event.event_lines.should_receive(:build).with(@lines[line])      
        end
        @fiscal_year.build_event(@event, @lines)
      end

      it "should not add line where both debit and credit are empty" do
        @event.event_lines.should_not_receive(:build).with(@lines["4"])
        @fiscal_year.build_event(@event, @lines)
      end

      it "should return the event" do
        @fiscal_year.build_event(@event, @lines).should == @event
      end
      
      describe "when lines an array" do
        before(:each) do
          @lines = @lines.values
        end
        it "should still return the event" do
          @fiscal_year.build_event(@event, @lines).should == @event
        end
      end
    end
  end
end
