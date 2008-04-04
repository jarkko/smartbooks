class Account < ActiveRecord::Base
  acts_as_tree :order => "account_number"
  has_many :event_lines
  
  def self.parse_array(fiscal_year, arr, parent = nil)
    new_account = fiscal_year.accounts.create!(:account_number => arr[1],
                                :title => arr[2],
                                :parent_id => parent ? parent.id : nil)
                                
    unless arr[3].blank?
      arr[3].each do |account|
        self.parse_array(fiscal_year, account, new_account)
      end
    end
    
    new_account
  end
  
  def self.find_virtual
    find_all_by_account_number("-1")
  end
  
  def self.find_for_dropdown
    find(:all, :conditions => ["account_number <> '-1'"],
          :order => "title")
  end
  
  def print_tree(level = 0)
    puts (" " * level * 2) + self.title + " " +
      result.to_s
    self.children.each do |child|
      child.print_tree(level + 1)
    end
  end
  
  def result
    if account_number == "-1"
      self.children.map{|child| child.result}.sum
    else
      self.event_lines.sum(:amount) || 0
    end
  end
end
