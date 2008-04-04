require File.dirname(__FILE__) + '/../../spec_helper'

describe "/event_lines/show.rhtml" do
  include EventLinesHelper
  
  before do
    @event_line = mock_model(EventLine)

    assigns[:event_line] = @event_line
  end

  it "should render attributes in <p>" do
    render "/event_lines/show.rhtml"

  end
end

