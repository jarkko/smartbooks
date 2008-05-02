class Account < ActiveRecord::Base
  acts_as_tree :order => "account_number"
  has_many :event_lines
  belongs_to :fiscal_year
  
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
  
  def total(opts = {})
    sql_opts = {}
    if opts[:month]
      
      if opts[:month].is_a?(Range)
        first = opts[:month].first.to_i
        last = Date.new(fiscal_year.start_date.year, opts[:month].last.to_i, 1)
        end_date = 1.month.since(last).yesterday
      else
        first = opts[:month].to_i
      end
      
      start_date = Date.new(fiscal_year.start_date.year, first, 1)
      end_date ||= 1.month.since(start_date).yesterday
      
      sql_opts = {:joins => "join events on event_lines.event_id = events.id",
                  :conditions => "event_date between '#{start_date.to_s(:db)}' and '#{end_date.to_s(:db)}'"}
    end
    
    if opts[:only]
      operator = opts[:only] == :credit ? "<" : ">"
      condition = "amount #{operator} 0"
      if sql_opts[:conditions]
        sql_opts[:conditions] << " and #{condition}"
      else
        sql_opts[:conditions] = condition
      end
    end
    
    sum = event_lines.sum(:amount, sql_opts) || 0
    
    opts[:formatted] ? sprintf("%+.2f", sum / 100.0) : sum
  end
  
  def formatted_total(opts = {})
    total(opts.merge(:formatted => true))
  end
end
