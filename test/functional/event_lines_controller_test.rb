require File.dirname(__FILE__) + '/../test_helper'
require 'event_lines_controller'

# Re-raise errors caught by the controller.
class EventLinesController; def rescue_action(e) raise e end; end

class EventLinesControllerTest < Test::Unit::TestCase
  fixtures :event_lines

  def setup
    @controller = EventLinesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:event_lines)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_event_line
    old_count = EventLine.count
    post :create, :event_line => { }
    assert_equal old_count+1, EventLine.count
    
    assert_redirected_to event_line_path(assigns(:event_line))
  end

  def test_should_show_event_line
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_event_line
    put :update, :id => 1, :event_line => { }
    assert_redirected_to event_line_path(assigns(:event_line))
  end
  
  def test_should_destroy_event_line
    old_count = EventLine.count
    delete :destroy, :id => 1
    assert_equal old_count-1, EventLine.count
    
    assert_redirected_to event_lines_path
  end
end
