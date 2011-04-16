require 'digest/sha1'
class EventsController < ApplicationController
  before_filter :get_fiscal_year
  
  
  
  # GET /events
  # GET /events.xml
  def index
    options = {:order => "event_date, receipt_number", 
               :include => {:event_lines => :account}}
    if params[:start_date]
      start = Date.parse(params[:start_date])
      options[:conditions] = ["event_date >= ?", start.to_s(:db)]
    end
    
    if params[:end_date]
      end_date = Date.parse(params[:end_date])
      if options[:conditions]
        options[:conditions][0] << " and "
      else
        options[:conditions] = [""]
      end
      options[:conditions][0] << "event_date <= ?"
      options[:conditions] << end_date.to_s(:db)
    end
    
    @events = @fiscal_year.events.find(:all, options)
  end

  # GET /events/new
  def new
    session[:forms] ||= []
    @form_token = Digest::SHA1.hexdigest("--#{Time.now}--#{rand(1000)}--#{session[:id]}--")
    session[:forms] << @form_token
    
    @event = Event.new
    @accounts = @fiscal_year.accounts.find_for_dropdown
    @lines = []
    4.times { @lines << EventLine.new }
  end

  # GET /events/1;edit
  def edit
    @event = @fiscal_year.events.find(params[:id])
    @accounts = @fiscal_year.accounts.find_for_dropdown
    @lines = []
    @lines += @event.event_lines
    2.times { @lines << EventLine.new }
  end

  # POST /events
  # POST /events.xml
  def create  
    @event = @fiscal_year.create_event(params[:event], params[:line])
    @event.save!
    flash[:notice] = 'Event was successfully created.'
    redirect_to fiscal_year_events_url(:fiscal_year_id => @fiscal_year,
                            :anchor => "event_#{@event.to_param}")

  rescue ActiveRecord::RecordInvalid
    flash[:warning] = 'Saving event failed.'
    @lines = @event.event_lines
    2.times { @lines << EventLine.new }
    @accounts = Account.find_for_dropdown

    render :action => "new"
  end

  def update
    @event = @fiscal_year.events.find(params[:id])
    @event.update_attributes!(params[:event])
    @event.update_lines!(params[:line])
    flash[:notice] = 'Event was successfully updated.'
    redirect_to fiscal_year_events_url(:fiscal_year_id => @fiscal_year,
                            :anchor => "event_#{@event.to_param}")
    rescue ActiveRecord::RecordInvalid
      flash[:warning] = 'Saving event failed.'
      @lines = @event.event_lines
      2.times { @lines << EventLine.new }
      @accounts = Account.find_for_dropdown

      render :action => "edit"
  end
end
