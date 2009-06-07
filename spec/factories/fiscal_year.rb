Factory.define :fiscal_year, :default_strategy => :stub do |f|
  f.description             "2008"
  f.start_date              Date.new(2008,1,1)
  f.end_date                Date.new(2008,12,31)
  f.copy_accounts_from      nil
  f.copy_balance            nil
  
  f.add_attribute(:id, "69")
end
