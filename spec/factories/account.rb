Factory.define :account, :default_strategy => :stub do |a|
  a.title "Bank account"
  a.add_attribute(:id, 1)
end
