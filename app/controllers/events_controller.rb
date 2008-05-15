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

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @event.to_xml }
    end
  end

  # GET /events/new
  def new
    session[:forms] ||= []
    @form_token = Digest::SHA1.hexdigest("--#{Time.now}--#{rand(1000)}--#{session[:id]}--")
    session[:forms] << @form_token
    
    @event = Event.new
    @accounts = Account.find_for_dropdown
    @lines = []
    4.times { @lines << EventLine.new }
  end

  # GET /events/1;edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.xml
  def create
    #unless params[:form_token] && 
    #       session[:forms].include?(params[:form_token])
    #  flash[:warning] = "The form was already posted"
    #  return redirect_to(fiscal_year_events_path(@fiscal_year))
    #end
    #session[:forms].delete(params[:form_token])
    
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

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to event_url(@event) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors.to_xml }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def get_fiscal_year
    @fiscal_year = FiscalYear.find(params[:fiscal_year_id]) rescue nil
    
    unless @fiscal_year
      not_found
      return false
    end
  end
end
