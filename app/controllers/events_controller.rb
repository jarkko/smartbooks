# -*- encoding : utf-8 -*-
require 'digest/sha1'
class EventsController < ApplicationController
  before_filter :get_fiscal_year



  # GET /events
  # GET /events.xml
  def index
    @events = @fiscal_year.ordered_events(params[:start_date], params[:end_date])
      #if params[:start_date]
      #start = Date.parse(params[:start_date])
      #@events = @events.where(["event_date >= ?", start.to_s(:db)])
    #end

    #if params[:end_date]
      #end_date = Date.parse(params[:end_date])
      #@events = @events.where(["event_date <= ?", end_date.to_s(:db)])
    #end
  end

  # GET /events/new
  def new
    @event = Event.new
    @accounts = @fiscal_year.accounts.find_for_dropdown
    @lines = []
    fetch_preliminary_data

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
    #@event = @fiscal_year.create_event(params[:event], params[:line])
    @event = @fiscal_year.events.build(cleaned_up_event_params(params[:event]))
    @event.save!
    flash[:notice] = 'Event was successfully created.'
    redirect_to fiscal_year_events_url(:fiscal_year_id => @fiscal_year,
                            :anchor => "event_#{@event.to_param}")

  rescue ActiveRecord::RecordInvalid
    flash[:warning] = 'Saving event failed.'
    @lines = @event.event_lines
    2.times { @lines << EventLine.new }
    @accounts = @fiscal_year.accounts.find_for_dropdown

    render :action => "new"
  end

  def update
    @event = @fiscal_year.events.find(params[:id])
    @event.update_attributes!(cleaned_up_event_params(params[:event]))
    #@event.update_lines!(params[:line])
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

  private

    def cleaned_up_event_params(params)
      params[:event_lines_attributes].reject!{|k,v| (v[:debit].blank? && v[:credit].blank?) || v[:debit] == v[:credit] }
      params
    end

    def fetch_preliminary_data
      if params[:preliminary_event_id].present?
        @preliminary_event = @fiscal_year.preliminary_events.where(:id => params[:preliminary_event_id]).first

        if @preliminary_event
          @event.description = @preliminary_event.description
          @event.event_date = @preliminary_event.booking_date
          @event.receipt_number = @preliminary_event.reference
          @lines << EventLine.new do |el|
            el.account = @preliminary_event.account
            el.amount = @preliminary_event.amount_cents
          end
        end
      end
    end
end
