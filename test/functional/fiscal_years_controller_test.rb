require File.dirname(__FILE__) + '/../test_helper'
require 'fiscal_years_controller'

# Re-raise errors caught by the controller.
class FiscalYearsController; def rescue_action(e) raise e end; end

class FiscalYearsControllerTest < Test::Unit::TestCase
  fixtures :fiscal_years

  def setup
    @controller = FiscalYearsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:fiscal_years)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_fiscal_year
    old_count = FiscalYear.count
    post :create, :fiscal_year => { }
    assert_equal old_count+1, FiscalYear.count
    
    assert_redirected_to fiscal_year_path(assigns(:fiscal_year))
  end

  def test_should_show_fiscal_year
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_fiscal_year
    put :update, :id => 1, :fiscal_year => { }
    assert_redirected_to fiscal_year_path(assigns(:fiscal_year))
  end
  
  def test_should_destroy_fiscal_year
    old_count = FiscalYear.count
    delete :destroy, :id => 1
    assert_equal old_count-1, FiscalYear.count
    
    assert_redirected_to fiscal_years_path
  end
end
