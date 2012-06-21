# -*- encoding : utf-8 -*-
class AccountsController < ApplicationController
  before_filter :get_fiscal_year

  def index
    @accounts = @fiscal_year.accounts.find_for_dropdown
  
    respond_to do |format|
      format.js { render :json => "var accounts = " + @accounts.to_json(:only => [:title, :id]) }
    end
  end

  def show
    options = {:include => [:event_lines => :event]}
    
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
    
    @account = @fiscal_year.accounts.find(params[:id], options)
  end
end
