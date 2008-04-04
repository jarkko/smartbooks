require File.dirname(__FILE__) + '/../../spec_helper'

describe "/event_lines/edit.rhtml" do
  include EventLinesHelper
  
  before do
    @event_line = mock_model(EventLine)
    assigns[:event_line] = @event_line
  end

  it "should render edit form" do
    render "/event_lines/edit.rhtml"
    
    response.should have_tag("form[action=#{event_line_path(@event_line)}][method=post]") do
    end
  end
end


