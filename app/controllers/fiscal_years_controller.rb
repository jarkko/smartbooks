class FiscalYearsController < ApplicationController
  # GET /fiscal_years
  # GET /fiscal_years.xml
  def index
    @fiscal_years = FiscalYear.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @fiscal_years.to_xml }
    end
  end

  # GET /fiscal_years/1
  # GET /fiscal_years/1.xml
  def show
    @fiscal_year = FiscalYear.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @fiscal_year.to_xml }
    end
  end

  # GET /fiscal_years/new
  def new
    @fiscal_year = FiscalYear.new
  end

  # GET /fiscal_years/1;edit
  def edit
    @fiscal_year = FiscalYear.find(params[:id])
  end

  # POST /fiscal_years
  # POST /fiscal_years.xml
  def create
    @fiscal_year = FiscalYear.new(params[:fiscal_year])

    respond_to do |format|
      if @fiscal_year.save
        flash[:notice] = 'FiscalYear was successfully created.'
        format.html { redirect_to fiscal_year_url(@fiscal_year) }
        format.xml  { head :created, :location => fiscal_year_url(@fiscal_year) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @fiscal_year.errors.to_xml }
      end
    end
  end

  # PUT /fiscal_years/1
  # PUT /fiscal_years/1.xml
  def update
    @fiscal_year = FiscalYear.find(params[:id])

    respond_to do |format|
      if @fiscal_year.update_attributes(params[:fiscal_year])
        flash[:notice] = 'FiscalYear was successfully updated.'
        format.html { redirect_to fiscal_year_url(@fiscal_year) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @fiscal_year.errors.to_xml }
      end
    end
  end

  # DELETE /fiscal_years/1
  # DELETE /fiscal_years/1.xml
  def destroy
    @fiscal_year = FiscalYear.find(params[:id])
    @fiscal_year.destroy

    respond_to do |format|
      format.html { redirect_to fiscal_years_url }
      format.xml  { head :ok }
    end
  end
end
