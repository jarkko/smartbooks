# -*- encoding : utf-8 -*-

class FiscalYear < ActiveRecord::Base
  attr_accessor :copy_accounts_from, :copy_balance

  validates_presence_of :start_date, :end_date, :description

  has_many :accounts, :dependent => :destroy
  has_many :events, :dependent => :destroy
  has_many :preliminary_events, :dependent => :destroy

  before_create :copy_accounts_if_needed
  after_create :copy_balance_if_needed

  def payable_vat_for(month)
    sum = vat_balance_for(month)
    sum = sum < 0.00 ? sum.abs : 0
    sprintf("%.2f", sum / 100.0)
  end

  def transferred_vat_receivables_for(month)
    sum = vat_balance_for(month)
    sum = sum > 0.00 ? sum : 0
    sprintf("%.2f", sum / 100.0)
  end

  def FiscalYear.account_names
    {:assets => "Vastaavaa",
     :liabilities => "Vastattavaa",
     :current_assets => "VAIHTUVAT VASTAAVAT",
     :longterm_assets => "PYSYVÄT VASTAAVAT",
     :vat_debt => "Arvonlisäverovelka 22%",
     :vat_payable => "Tilitysvelat",
     :accounts_payable => "Ostovelat",
     :current_liabilities => "Lyhytaikainen vieras pääoma",
     :vat_receivables => "Arvonlisäverosaamiset",
     :sales => "Myyntituotot",
     :interest_income => "Muut korko- ja rahoitustuotot",
     :purchases => "Aineet, tarvikkeet ja tavarat",
     :services => "Palvelut",
     :depreciation => "Poistot",
     :other_expenses => "Liiketoiminnan muut kulut",
     :interest_expenses => "Korkokulut ja muut rahoituskulut",
     :taxes => "Verot",
     :bank_accounts => "Pankkisaamiset",
     :short_term_receivables => "Lyhytaikaiset saamiset",
     :accounts_receivable => "Myyntisaamiset",
     :vat_returns => "Anotut arvonlisäveropalautukset",
     :equipment => "Koneet ja kalusto",
     :equity => "OMA PÄÄOMA",
     :stockholders_equity => "Oma pääoma (tilinavaus)",
     :private_equity => "Yksityistilit tilikaudella",
     :cash_private_investments => "Yksityissijoitukset rahana",
     :other_private_investments => "Muut yksityissijoitukset",
     :cash_private_withdraws => "Yksityisnostot rahana",
     :other_private_withdraws => "Muut yksityisnostot"}
  end

  self.account_names.each do |account, account_name|
    define_method(account) do
      accounts.find_by_title(account_name)
    end
  end

  def total_income
    sales.result + interest_income.result
  end

  def total_expenses
    purchases.result +
    services.result +
    depreciation.result +
    other_expenses.result +
    interest_expenses.result
  end

  def net_income_before_taxes
    -1 * (total_income + total_expenses)
  end

  def net_operating_income
    net_income_before_taxes - interest_income.result.abs
  end

  def net_income
    net_income_before_taxes - taxes.result
  end

  def private_equity_result
    -1 * private_equity.result
  end

  def liabilities_result
    -1 * stockholders_equity.result +
    private_equity_result +
    net_income +
    current_liabilities.result.abs
  end

  def create_event(event_hsh, lines_hsh)
    logger.debug("*** Creating event with the following details: event: #{event_hsh.inspect}\n lines_hsh: #{lines_hsh.inspect}")
    event = build_event(event_hsh, lines_hsh)
    event.save
    return event
  end

  def build_event(event_hsh, lines_hsh)
    event = events.build(event_hsh)
    lines = lines_hsh.respond_to?(:values) ? lines_hsh.values : lines_hsh
    lines.each do |line|
      logger.debug("*** Adding line #{line.inspect} for event #{event.inspect}")
      line.stringify_keys!
      next if %w(credit debit amount).all? { |i| line[i].blank? }
      el = event.event_lines.build(line)
      logger.debug("*** Added line #{el.inspect} for event #{event.inspect}")
    end

    event
  end

  def ordered_events(start_date = nil, end_date = nil)
    ret = events.order("event_date, receipt_number").
                 includes({:event_lines => :account})
    ret = ret.where(["event_date >= ?", Date.parse(start_date)]) if start_date.present?
    ret = ret.where(["event_date <= ?", Date.parse(end_date)]) if end_date.present?
    ret
  end

  def create_account_from_array(arr, parent = nil)
    logger.debug("++++ accounts: #{arr.inspect}")

    logger.debug("::::: create_account_from_array called with arr: #{arr.inspect}, parent: #{parent.inspect}")

    logger.debug("** calling create! with account number: #{arr[1].to_s.to_i.to_s.inspect}, title: #{arr[2].inspect}, parent: #{parent.inspect}")
    new_account = accounts.create!(:account_number => arr[1].to_s.to_i.to_s,
                                   :title => arr[2],
                                   :parent => parent)

    unless arr[3].blank?
      arr[3].each do |account|
        create_account_from_array(account, new_account)
      end
    end

    new_account
  end

  def timeline
    [start_date, end_date].map{|d| "#{d.day}.#{d.month}.#{d.year}"}.join(" - ")
  end

  def description_with_dates
    "#{description} (#{timeline})".strip
  end

  private

  def vat_balance_for(month)
    month = month.to_i
    vat_debt.total(:month => month) + vat_receivables.total(:month => 1..month)
  end

  def copy_accounts_if_needed
    return true if copy_accounts_from.blank?
    copy_accounts(copy_accounts_from)
  end

  def copy_balance_if_needed
    return true if copy_accounts_from.blank? || copy_balance.blank?
    copy_balance_from(copy_accounts_from)
  end

  def copy_accounts(source_year)
    source = FiscalYear.find(source_year)
    source.accounts.find_all_by_parent_id(nil).each do |source_account|
      copy_account(source_account)
    end
  end

  def copy_account(source_account)
    logger.debug("*** COPYING ACCOUNT #{source_account.inspect}")
    account = accounts.build(source_account.attributes.except("id").
                            except("fiscal_year_id").
                            except("parent_id"))

    logger.debug("** BUILT ACCOUNT #{account.inspect}")

    source_account.children.each do |child|
      account.children << copy_account(child)
    end

    account
  end

  def copy_balance_from(source_year)
    source = FiscalYear.find(source_year)
    logger.debug("*** copying balance from #{source.inspect}")
    balance_accounts = accounts.select do |acc|
      %w(Vastaavaa Vastattavaa).include?(acc.title)
    end
    logger.debug("*** balance_accounts: #{balance_accounts.map{|a| a.title}.inspect}")
    balance_accounts.each do |account|
      logger.debug("*** all children of #{account.title}: #{account.all_children.map{|a| a.title}.inspect}")

      account.all_children.each do |child|
        original = source.accounts.detect do |acc|
          acc.account_number == child.account_number &&
          acc.description == child.description
        end

        next if original.nil? ||
                equity.all_children.include?(child) ||
                child.account_number == "-1" ||
                original.total == 0

        logger.debug("*** copying balance for #{child.title}")
        logger.debug("*** balance: #{original.total}")
        child.open_account_from(original)
      end
    end
  end

  def balance_accounts

  end
end
