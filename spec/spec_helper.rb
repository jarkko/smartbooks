# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec'
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
                             :copy_accounts_from => nil)
    
    FiscalYear.account_names.each do |key, name|
      instance_variable_set("@#{key}", 
                            mock_model(Account,
                                       :title => name,
                                       :result => (((-1) ** rand(2)) *
                                                   rand(100000))))
      fiscal_year.stub!(key).and_return(instance_variable_get("@#{key}"))
    end

    @subaccounts = [mock_model(Account, :title => "Myynti 22%", :result => -54000),
      mock_model(Account, :title => "Myynti 0%", :result => -15000)]  
    @sales.stub!(:children).and_return(@subaccounts)
    
    @bank_accounts.stub!(:children).and_return(
      [mock_model(Account, :title => "Sampo", :result => 30000),
       mock_model(Account, :title => "Nordea", :result => 15000)])
    
    
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
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  config.include(FiscalYearSpecHelper)
  
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
end