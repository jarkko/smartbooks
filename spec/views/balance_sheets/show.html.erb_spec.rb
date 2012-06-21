# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../../spec_helper'

describe "/balance_sheets/show" do
  include FiscalYearSpecHelper
  include ApplicationHelper

  before(:each) do
    assigns[:fiscal_year] = @fiscal_year = mock_fiscal_year
  end

  describe "when net income positive" do
    before(:each) do
      render
    end

    it "should show the balance of bank accounts" do
      rendered.should have_selector("th", :content =>
                          formatted(@fiscal_year.bank_accounts.result.abs))
    end

    it "should show the result of each individual bank account" do
      @fiscal_year.bank_accounts.children.each do |account|
        rendered.should have_selector("td", :content => account.title)
        rendered.should have_selector("td", :content => formatted(account.result))
      end
    end

    it "should show the balance of short-term receivables" do
      rendered.should have_selector("th", :content =>
                          formatted(@fiscal_year.short_term_receivables.result.abs))
    end

    [:accounts_receivable, :vat_receivables, :vat_returns,
     :equipment].each do |account|
      it "should show #{account.to_s.humanize}" do
        rendered.should have_selector("#assets") do |el|
          el.should have_selector "td", :content => @fiscal_year.send(account).title
          el.should have_selector "td", :content => formatted(@fiscal_year.send(account).result.abs)
        end
      end
    end

    it "should show the total of current assets" do
      rendered.should have_selector("th", :content =>
                          formatted(@fiscal_year.current_assets.result.abs))
    end

    it "should show the total of long-term assets" do
      rendered.should have_selector("th", :content =>
                          formatted(@fiscal_year.longterm_assets.result.abs))
    end

    it "should show the total of all assets" do
      rendered.should have_selector("th", :content =>
                          formatted(@fiscal_year.assets.result.abs))
    end

    [:cash_private_investments,
     :other_private_investments,
     :vat_debt, :vat_payable, :accounts_payable].each do |account|
      it "should show #{account.to_s.humanize}" do
        rendered.should have_selector("#liabilities") do |el|
          el.should have_selector "td", :content => @fiscal_year.send(account).title
          el.should have_selector "td", :content => formatted(@fiscal_year.send(account).result.abs)
        end
      end
    end

    it "should show stockholder's equity times -1" do
      rendered.should have_selector("#liabilities") do |el|
        el.should have_selector "td", :content => @fiscal_year.stockholders_equity.title
        el.should have_selector "td", :content => formatted(-1 * @fiscal_year.stockholders_equity.result)
      end
    end

    [:cash_private_withdraws,
     :other_private_withdraws].each do |account|
      it "should show #{account.to_s.humanize} as negative balance" do
        rendered.should have_selector("#liabilities") do |el|
          el.should have_selector "td", :content => @fiscal_year.send(account).title
          el.should have_selector "td", :content => formatted(@fiscal_year.send(account).result.abs * -1)
        end
      end
    end

    it "should show the total of private equity" do
      rendered.should have_selector("th", :content => formatted(@fiscal_year.private_equity_result))
    end

    it "should show the total income of the fiscal year" do
      rendered.should have_selector("th", :content => "Tilikauden voitto")
      rendered.should have_selector("th", :content => formatted(@fiscal_year.net_income))
    end

    it "should show the total of current liabilities" do
      rendered.should have_selector("th", :content => formatted(@fiscal_year.current_liabilities.result.abs))
    end

    it "should show total liabilities" do
      rendered.should have_selector("tr") do |el|
        el.should have_selector("th", :content => "Vastattavat yhteensä")
        el.should have_selector("th", :content => formatted(@fiscal_year.liabilities_result))
      end
    end
  end

  describe "when net income is negative" do
    before(:each) do
      @fiscal_year.stub!(:net_income).and_return(-65001)
      render
    end

    it "should show the net loss text" do
      rendered.should have_selector("th", :content => "Tilikauden tappio")
      rendered.should have_selector("th", :content => formatted(@fiscal_year.net_income))
    end
  end
end
