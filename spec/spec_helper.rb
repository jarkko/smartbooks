# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)
require 'spec/autorun'
require 'spec/rails'

module FiscalYearSpecHelper
  def mock_fiscal_year
    fiscal_year = mock_model(FiscalYear,
                             :net_income_before_taxes => 7500000,
                             :net_operating_income => 7400000,
                             :net_income => 6900000,
                             :description => "2008",
                             :start_date => Date.new(2008,1,1),
                             :end_date => Date.new(2008,12,31),
                             :to_param => "69",
                             :copy_accounts_from => nil,
                             :copy_balance => nil)
                             
    fiscal_year.stub!(:accounts).and_return([])
    
    FiscalYear.account_names.each do |key, name|
      amount = (((-1) ** rand(2)) * rand(100000))
      account = stub_model(Account,
                           :result => amount,
                           :total => amount) do |acc|
        acc.title = name
      end
      
      instance_variable_set("@#{key}", account)
      fiscal_year.accounts << account
      fiscal_year.stub!(key).and_return(instance_variable_get("@#{key}"))
    end

    @subaccounts = [
      stub_model(Account, :result => -54000) do |acc|
        acc.title = "Myynti 22%"
      end,
      stub_model(Account, :result => -15000) do |acc|
        acc.title = "Myynti 0%"
      end
    ]  
    @sales.stub!(:children).and_return(@subaccounts)
    fiscal_year.accounts.concat(@subaccounts)
    
    @bank_accounts.stub!(:children).and_return(
      [
        stub_model(Account, :result => 30000) do |acc|
          acc.title = "Sampo"
          acc.parent_id = @bank_accounts.id
        end,
        stub_model(Account, :result => 15000) do |acc|
          acc.title = "Nordea"
          acc.parent_id = @bank_accounts.id
        end
      ])
    fiscal_year.accounts.concat(@bank_accounts.children)
    
    
    @total_income = @sales.result + @interest_income.result
    fiscal_year.stub!(:total_income).and_return(@total_income)  

    @total_expenses = @purchases.result +
                      @services.result +
                      @depreciation.result +
                      @other_expenses.result +
                      @interest_expenses.result
                      
    fiscal_year.stub!(:total_expenses).and_return(@total_expenses)
    fiscal_year.stub!(:liabilities_result).and_return(6900000)
    fiscal_year.stub!(:private_equity_result).and_return(-1 * @private_equity.result)
    
    fiscal_year.errors.stub!(:on).and_return([])
    
    fiscal_year
  end
end

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # You can also declare which fixtures to use (for example fixtures for test/fixtures):
  #
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  #
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  
  config.include(FiscalYearSpecHelper)
  
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # == Notes
  # 
  # For more information take a look at Spec::Runner::Configuration and Spec::Runner
end

module EventsControllerSpecHelper
  def valid_attributes
    {:fiscal_year_id => 1, 
     :line => event_lines,
     :event => {:receipt_number => "", :description => "yrittäjäeläkemaksu",
                "event_date(1i)" => "2007", "event_date(2i)" => "8", 
                "event_date(3i)" => "27"}}
  end
  
  def do_post
    post :create, valid_attributes.except(:fiscal_year_id)
  end

  def event_lines
    {"1" => {"debit" => "", "account_id" => "380", "credit" => "60"}, 
    "2" => {"debit" => "50", "account_id" => "398", "credit" => ""}, 
    "3" => {"debit" => "10", "account_id" => "359", "credit" => ""}, 
    "4" => {"debit" => "", "account_id" => "357", "credit" => ""}}
  end
  
  def prepare_events
    @event = mock_model(Event)
    Event.stub!(:find).and_return([@event])
    @fy = mock_model(FiscalYear)
    FiscalYear.stub!(:find).and_return(@fy)
    @events = [@event]
    @events.stub!(:find).and_return(@events)
    @fy.stub!(:events).and_return(@events)
  end
end