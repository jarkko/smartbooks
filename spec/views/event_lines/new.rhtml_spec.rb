require File.dirname(__FILE__) + '/../../spec_helper'

describe "/event_lines/new.rhtml" do
  include EventLinesHelper
  
  before do
    @event_line = mock_model(EventLine)
    @event_line.stub!(:new_record?).and_return(true)
    assigns[:event_line] = @event_line
  end

  it "should render new form" do
    render "/event_lines/new.rhtml"
    
    response.should have_tag("form[action=?][method=post]", event_lines_path) do
    end
  end
end


