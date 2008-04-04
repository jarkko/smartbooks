class AccountsController < ApplicationController
  # GET /accounts
  # GET /accounts.xml
  #def index
  #  @accounts = Account.find(:all)
  #
  #  respond_to do |format|
  #    format.html # index.rhtml
  #    format.xml  { render :xml => @accounts.to_xml }
  #  end
  #end

  # GET /accounts/1
  # GET /accounts/1.xml
  def show
    @fiscal_year = FiscalYear.find(params[:fiscal_year_id])
    @account = @fiscal_year.accounts.find(params[:id], :include => [:event_lines => :event])
  end

  # GET /accounts/new
  #def new
  #  @account = Account.new
  #end
  #
  ## GET /accounts/1;edit
  #def edit
  #  @account = Account.find(params[:id])
  #end
  #
  ## POST /accounts
  ## POST /accounts.xml
  #def create
  #  @account = Account.new(params[:account])
  #
  #  respond_to do |format|
  #    if @account.save
  #      flash[:notice] = 'Account was successfully created.'
  #      format.html { redirect_to account_url(@account) }
  #      format.xml  { head :created, :location => account_url(@account) }
  #    else
  #      format.html { render :action => "new" }
  #      format.xml  { render :xml => @account.errors.to_xml }
  #    end
  #  end
  #end
  #
  ## PUT /accounts/1
  ## PUT /accounts/1.xml
  #def update
  #  @account = Account.find(params[:id])
  #
  #  respond_to do |format|
  #    if @account.update_attributes(params[:account])
  #      flash[:notice] = 'Account was successfully updated.'
  #      format.html { redirect_to account_url(@account) }
  #      format.xml  { head :ok }
  #    else
  #      format.html { render :action => "edit" }
  #      format.xml  { render :xml => @account.errors.to_xml }
  #    end
  #  end
  #end
  #
  ## DELETE /accounts/1
  ## DELETE /accounts/1.xml
  #def destroy
  #  @account = Account.find(params[:id])
  #  @account.destroy
  #
  #  respond_to do |format|
  #    format.html { redirect_to accounts_url }
  #    format.xml  { head :ok }
  #  end
  #end
end
