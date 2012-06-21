# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :fiscal_year do
    description             "2008"
    start_date              Date.new(2008,1,1)
    end_date                Date.new(2008,12,31)
    copy_accounts_from      nil
    copy_balance            nil

    add_attribute(:id, "69")
  end
end
