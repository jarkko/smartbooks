class FiscalYear < ActiveRecord::Base
  has_many :accounts
  has_many :events
end
