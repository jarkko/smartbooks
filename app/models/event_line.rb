class EventLine < ActiveRecord::Base
  attr_accessor :account_name
  
  belongs_to :account
  belongs_to :event
  
  validates_presence_of :account_id
  
  def validate
    @virtual_accounts ||= Account.find_virtual
    
    if @virtual_accounts.map(&:id).include?(account_id)
      errors.add :account, "must be an actual account"
    end
  end
  
  def sum
    sprintf("%+.2f", amount / 100.0)
  end
  
  def debit
    amount.to_f > 0 ? amount.to_f / 100 : ""
  end
  
  def credit
    amount.to_f < 0 ? -amount.to_f / 100 : ""
  end
  
  def credit=(amnt)
    escape_comma(amnt)
    self.amount = (self.amount.to_f - amnt.to_f * 100).round
  end
  
  def debit=(amnt)
    escape_comma(amnt)
    self.amount = (self.amount.to_f + amnt.to_f * 100).round
  end
  
  private
  
    def escape_comma(str)
      str.gsub!(",", ".") if str.is_a?(String)
    end
end
