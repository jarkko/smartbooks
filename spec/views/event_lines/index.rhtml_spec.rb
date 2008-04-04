require File.dirname(__FILE__) + '/../../spec_helper'

describe "/event_lines/index.rhtml" do
  include EventLinesHelper
  
  before do
    event_line_98 = mock_model(EventLine)

    event_line_99 = mock_model(EventLine)

    assigns[:event_lines] = [event_line_98, event_line_99]
  end

  it "should render list of event_lines" do
    render "/event_lines/index.rhtml"

  end
end

