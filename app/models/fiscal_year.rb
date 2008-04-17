class FiscalYear < ActiveRecord::Base
  has_many :accounts
  has_many :events
  
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
    {:vat_debt => "Arvonlisäverovelka 22%",
     :vat_receivables => "Arvonlisäverosaamiset",
     :sales => "Myyntituotot",
     :interest_income => "Muut korko- ja rahoitustuotot",
     :purchases => "Aineet, tarvikkeet ja tavarat",
     :services => "Palvelut",
     :depreciation => "Poistot",
     :other_expenses => "Liiketoiminnan muut kulut",
     :interest_expenses => "Korkokulut ja muut rahoituskulut",
     :taxes => "Verot"}
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
  
  private
  
  def vat_balance_for(month)
    month = month.to_i
    vat_debt.total(:month => month) + vat_receivables.total(:month => 1..month)
  end
end
