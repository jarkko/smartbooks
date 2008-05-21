require File.dirname(__FILE__) + '/../spec_helper'

describe Account do
  before(:each) do
    @account = Account.new
  end

  it "should be valid" do
     @account.should be_valid
  end
end

describe Account, ", calling virtual accounts" do
  fixtures :fiscal_years, :accounts, :events
  
  before(:each) do
    @virtual_accounts = Account.find_virtual
  end
  
  it "should fetch all accounts with number -1 and nothing else" do
    @virtual_accounts.should == [accounts(:vastaavaa),
                                accounts(:vastattavaa),
                                accounts(:tulos)]
  end
end

describe Account, "calling find_for_dropdown" do
  fixtures :fiscal_years, :accounts, :events
  
  before(:each) do
    @accounts = Account.find_for_dropdown
    @virtual_accounts = Account.find_virtual
    @all_accounts = Account.find(:all)
  end

  it "should order alphabetically" do
    @accounts.should == (@all_accounts - @virtual_accounts).sort_by(&:title)
  end
  
  it "should not have virtual accounts" do
    (@accounts & @virtual_accounts).should be_empty
  end
end

describe Account do
  before(:each) do
    @account = Account.new
  end

  describe "total" do
    before(:each) do
      @line1 = mock_model(EventLine, :amount => 6900)
      @line2 = mock_model(EventLine, :amount => -1300)
      @lines = [@line1, @line2]
      @account.stub!(:event_lines).and_return(@lines)
      @fiscal_year = mock_model(FiscalYear,
                                :start_date => Date.new(2007,1,1),
                                :end_date => Date.new(2007,12,31))
      @account.fiscal_year = @fiscal_year
      @lines.stub!(:sum).and_return(5600)
    end
    
    describe "without month set" do
      it "should return the sum of all the lines" do
        @account.total.should == 5600
      end
      
      describe "and only option set to debit" do
        it "should only fetch the sum from positive lines" do
          @lines.should_receive(:sum).with(:amount,
              :conditions => "amount > 0")
          @account.total(:only => :debit)
        end
      end
      
      describe "and only option set to credit" do
        it "should only fetch the sum from negative lines" do
          @lines.should_receive(:sum).with(:amount,
              :conditions => "amount < 0")
          @account.total(:only => :credit)
        end
      end
      
      describe "when formatted parameter set" do
        it "should return the sum formatted" do
          @account.total(:formatted => true).should == "+56.00"
        end
      end
    end
    
    describe "with month option set" do
      it "should restrict to events within the time frame" do
        @lines.should_receive(:sum).with(:amount,
            :joins => "join events on event_lines.event_id = events.id", 
            :conditions => "event_date between '2007-08-01' and '2007-08-31'").
                and_return(-6000)
        @account.total(:month => "8").should == -6000
      end
    end
    
    describe "with month option set to a range" do
      it "should restrict to events within the time frame" do
        @lines.should_receive(:sum).with(:amount,
            :joins => "join events on event_lines.event_id = events.id", 
            :conditions => "event_date between '2007-01-01' and '2007-10-31'")
        @account.total(:month => 1..10)
      end
      
      describe "and only option set to debit" do
        it "should only fetch the sum from positive lines" do
          @lines.should_receive(:sum).with(:amount,
              :joins => "join events on event_lines.event_id = events.id", 
              :conditions => "event_date between '2007-01-01' and '2007-10-31' and amount > 0")
          @account.total(:month => 1..10, :only => :debit)
        end
      end
      
      describe "and only option set to credit" do
        it "should only fetch the sum from negative lines" do
          @lines.should_receive(:sum).with(:amount,
              :joins => "join events on event_lines.event_id = events.id", 
              :conditions => "event_date between '2007-01-01' and '2007-10-31' and amount < 0")
          @account.total(:month => 1..10, :only => :credit)
        end
      end
    end
  end
  
  describe "formatted_total" do
    it "should return the formatted total" do
      @account.should_receive(:total).with(:formatted => true).and_return("+69.00")
      @account.formatted_total.should == "+69.00"
    end
    
    it "should pass options to total" do
      @account.should_receive(:total).with(:month => 1..10,
                                           :formatted => true).
                                      and_return("+66.00")
      @account.formatted_total(:month => 1..10).should == "+66.00"
    end
  end
  
  describe "all_children" do
    before(:each) do
      %w(@a @a1 @a1a @b @b1 @b2).each do |account|
        instance_variable_set(account, 
                              stub_model(Account) do |acc|
                                acc.title = account
                              end)
      end
      
      @account.children << @a
      @a.children << @a1
      @a1.children << @a1a
      @account.children << @b
      @b.children.concat([@b1, @b2])
    end
    
    it "should return the whole stack of children recursively" do
      @account.all_children.should == [@a, @b, @a1, @a1a, @b1, @b2]
    end
  end
  
  describe "open_account_from" do
    before(:each) do
      @fiscal_year = stub_model(FiscalYear, :stockholders_equity => :stockholders_equity) do |fy|
        fy.start_date = Date.new(2008,1,1)
        fy.end_date = Date.new(2008,12,31)
      end
      
      @account.fiscal_year = @fiscal_year
      @account.title = "Bank account"
      
      @original = stub_model(Account, :total => 45000)
    end
    
    it "should open the account with an opening event copying the total of the corresponding source account" do
      @fiscal_year.should_receive(:create_event).with(
      {:event_date => @fiscal_year.start_date,
       :description => "Tilinavaus (#{@account.title})"},
      [{:amount => @original.total,
        :account => @account},
       {:amount => (-1 * @original.total),
        :account => :stockholders_equity}]
      )
      
      @account.open_account_from(@original)
    end
  end
end