require "sexp"

class SexpParser
  def initialize(str)
    @sexp_array = str.parse_sexp
  end
  
  def import
    @year = @sexp_array[5]
    @fy = FiscalYear.create!(:description => @year[1],
                            :start_date => Date.new(*fetch_date(@year[2])).to_s(:db),
                            :end_date => Date.new(*fetch_date(@year[3])).to_s(:db))

    @accounts = @year[4][1..-1]
    @accounts.each do |account|
      Account.parse_array(@fy, account)
    end
    
    Event.parse_events(@fy, @year[5])
  end
  
  private
  
  def fetch_date(date)
    date[1,3]
  end
end

# 0 identity
# 1 Tappio
# 2 version
# 3 versio 0.22
# 4 finances
# 5 fiscal year

# fiscal year:
# 0 fiscal-year
# 1 2007
# 2 ["date", 2007, 1, 1]
# 3 ["date", 2007, 12, 31]
# 4 account-map
# 5 list of events

# account-map
# 0 account-map
# 1-n recursive ["account", number, description, children]

# events
# 0 event
# 1 event number
# 2 ["date", 2007, 1, 4]
# 3 description
# 4 array of event lines

# event lines
# 0 account number
# 1 ["money", amount]