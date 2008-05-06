class FiscalYear < ActiveRecord::Base
  attr_accessor :copy_accounts_from
  
  has_many :accounts
  has_many :events
  
  before_create :copy_accounts_if_needed
  
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
    stockholders_equity.result.abs +
    private_equity_result +
    net_income +
    current_liabilities.result.abs
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
  
  def copy_accounts(source_year)
    source = FiscalYear.find(source_year)
    source.accounts.each do |account|
      new_account = Account.new(account.attributes.except("id").except("fiscal_year_id"))
      accounts << new_account
    end
  end
end
