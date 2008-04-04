class Event < ActiveRecord::Base
  before_create :set_receipt_number
  
  has_many    :event_lines, :dependent => :delete_all
  belongs_to  :fiscal_year
  
  validates_presence_of :event_date
  
  def validate
    unless event_lines.map(&:amount).sum == 0
      errors.add :event_lines, "must add up to zero"
    end
  end
  
  def self.parse_events(fiscal_year, arr)
    arr.each do |event|
      self.parse_event(fiscal_year, event)
    end
  end
  
  def self.parse_event(fiscal_year, event)
    logger.debug("EVENT SEXP: #{event.inspect}")
    @event = fiscal_year.events.build(:receipt_number => event[1],
                                :event_date => event[2][1..-1].map(&:to_i).join("-"),
                                :description => event[3])
                                
    @event_lines = event[4]
    logger.debug("EVENT LINES SEXP: #{@event_lines.inspect}")
    @event_lines.each do |el|
      @account = Account.find_by_account_number(el.first)
      @event.event_lines.build(:account_id => @account.id,
                                 :amount => el.last.last.to_s.to_i)
    end
    
    logger.debug("EVENT DATE: <#{@event.event_date.inspect}>")
    @event.save!
    @event
  end
  
  def self.next_receipt_number
    (maximum('receipt_number') + 1) || 1
  end
  
  private
  
    def set_receipt_number
      self.receipt_number = Event.next_receipt_number if receipt_number.blank?
    end
end
