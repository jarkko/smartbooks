# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_smartbooks_session_id'
  
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
