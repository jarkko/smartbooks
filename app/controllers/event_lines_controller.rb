class EventLinesController < ApplicationController
  # GET /event_lines
  # GET /event_lines.xml
  def index
    @event_lines = EventLine.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @event_lines.to_xml }
    end
  end

  # GET /event_lines/1
  # GET /event_lines/1.xml
  def show
    @event_line = EventLine.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @event_line.to_xml }
    end
  end

  # GET /event_lines/new
  def new
    @event_line = EventLine.new
  end

  # GET /event_lines/1;edit
  def edit
    @event_line = EventLine.find(params[:id])
  end

  # POST /event_lines
  # POST /event_lines.xml
  def create
    @event_line = EventLine.new(params[:event_line])

    respond_to do |format|
      if @event_line.save
        flash[:notice] = 'EventLine was successfully created.'
        format.html { redirect_to event_line_url(@event_line) }
        format.xml  { head :created, :location => event_line_url(@event_line) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event_line.errors.to_xml }
      end
    end
  end

  # PUT /event_lines/1
  # PUT /event_lines/1.xml
  def update
    @event_line = EventLine.find(params[:id])

    respond_to do |format|
      if @event_line.update_attributes(params[:event_line])
        flash[:notice] = 'EventLine was successfully updated.'
        format.html { redirect_to event_line_url(@event_line) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event_line.errors.to_xml }
      end
    end
  end

  # DELETE /event_lines/1
  # DELETE /event_lines/1.xml
  def destroy
    @event_line = EventLine.find(params[:id])
    @event_line.destroy

    respond_to do |format|
      format.html { redirect_to event_lines_url }
      format.xml  { head :ok }
    end
  end
end
