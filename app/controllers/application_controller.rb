# -*- encoding : utf-8 -*-
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  def not_found
    render :text => 'Not found', :status => 404
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
