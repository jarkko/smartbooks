require File.dirname(__FILE__) + '/../../spec_helper'

describe "/balance_sheets/show" do
  include FiscalYearSpecHelper
  include ApplicationHelper
  
  before(:each) do
    assigns[:fiscal_year] = @fiscal_year = mock_fiscal_year                                                  
  end
  
  describe "when net income positive" do
    before(:each) do
      render "/balance_sheets/show"
    end
    
    it "should show the balance of bank accounts" do
      response.should have_tag("th",
                          formatted(@fiscal_year.bank_accounts.result.abs))
    end

    it "should show the result of each individual bank account" do
      @fiscal_year.bank_accounts.children.each do |account|
        response.should have_tag("td", account.title)
        response.should have_tag("td", formatted(account.result))
      end
    end

    it "should show the balance of short-term receivables" do
      response.should have_tag("th",
                          formatted(@fiscal_year.short_term_receivables.result.abs))    
    end

    [:accounts_receivable, :vat_receivables, :vat_returns,
     :equipment].each do |account|
      it "should show #{account.to_s.humanize}" do
        response.should have_tag("#assets") do
          with_tag "td", @fiscal_year.send(account).title
          with_tag "td", formatted(@fiscal_year.send(account).result.abs)
        end
      end
    end

    it "should show the total of current assets" do
      response.should have_tag("th",
                          formatted(@fiscal_year.current_assets.result.abs))    
    end

    it "should show the total of long-term assets" do
      response.should have_tag("th",
                          formatted(@fiscal_year.longterm_assets.result.abs))    
    end

    it "should show the total of all assets" do
      response.should have_tag("th",
                          formatted(@fiscal_year.assets.result.abs))    
    end

    [:stockholders_equity, :cash_private_investments,
     :other_private_investments,
     :vat_debt, :vat_payable, :accounts_payable].each do |account|
      it "should show #{account.to_s.humanize}" do
        response.should have_tag("#liabilities") do
          with_tag "td", @fiscal_year.send(account).title
          with_tag "td", formatted(@fiscal_year.send(account).result.abs)
        end
      end
    end

    [:cash_private_withdraws,
     :other_private_withdraws].each do |account|
      it "should show #{account.to_s.humanize} as negative balance" do
        response.should have_tag("#liabilities") do
          with_tag "td", @fiscal_year.send(account).title
          with_tag "td", formatted(@fiscal_year.send(account).result.abs * -1)
        end
      end
    end

    it "should show the total of private equity" do
      response.should have_tag("th", formatted(@fiscal_year.private_equity_result))
    end

    it "should show the total income of the fiscal year" do
      response.should have_tag("th", "Tilikauden voitto")
      response.should have_tag("th", formatted(@fiscal_year.net_income))
    end
    
    it "should show the total of current liabilities" do
      response.should have_tag("th", formatted(@fiscal_year.current_liabilities.result.abs))
    end
    
    it "should show total liabilities" do
      response.should have_tag("tr") do
        with_tag("th", "Vastattavat yhteensä")
        with_tag("th", formatted(@fiscal_year.liabilities_result))
      end
    end
  end
  
  describe "when net income is negative" do
    before(:each) do
      @fiscal_year.stub!(:net_income).and_return(-65001)
      render "/balance_sheets/show"
    end
    
    it "should show the net loss text" do
      response.should have_tag("th", "Tilikauden tappio")
      response.should have_tag("th", formatted(@fiscal_year.net_income))
    end
  end
end
