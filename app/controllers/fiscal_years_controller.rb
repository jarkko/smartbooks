class FiscalYearsController < ApplicationController
  def index
    @fiscal_years = FiscalYear.find(:all)
  end
  
  # GET /fiscal_years/new
  def new
    @fiscal_year = FiscalYear.new
    @fiscal_years = FiscalYear.find(:all)
  end

  ## GET /fiscal_years/1;edit
  #def edit
  #  @fiscal_year = FiscalYear.find(params[:id])
  #end

  # POST /fiscal_years
  # POST /fiscal_years.xml
  def create
    respond_to do |format|
      if @fiscal_year = FiscalYear.create(params[:fiscal_year])
        flash[:notice] = "Fiscal year was successfully created"
        format.html { redirect_to fiscal_year_events_url(@fiscal_year) }
        format.xml  { head :created, :location => fiscal_year_url(@fiscal_year) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @fiscal_year.errors.to_xml }
      end
    end
  end

  ## PUT /fiscal_years/1
  ## PUT /fiscal_years/1.xml
  #def update
  #  @fiscal_year = FiscalYear.find(params[:id])
  #
  #  respond_to do |format|
  #    if @fiscal_year.update_attributes(params[:fiscal_year])
  #      flash[:notice] = 'FiscalYear was successfully updated.'
  #      format.html { redirect_to fiscal_year_url(@fiscal_year) }
  #      format.xml  { head :ok }
  #    else
  #      format.html { render :action => "edit" }
  #      format.xml  { render :xml => @fiscal_year.errors.to_xml }
  #    end
  #  end
  #end
  #
  ## DELETE /fiscal_years/1
  ## DELETE /fiscal_years/1.xml
  #def destroy
  #  @fiscal_year = FiscalYear.find(params[:id])
  #  @fiscal_year.destroy
  #
  #  respond_to do |format|
  #    format.html { redirect_to fiscal_years_url }
  #    format.xml  { head :ok }
  #  end
  #end
end
