require File.dirname(__FILE__) + '/../../spec_helper'

describe "/accounts/show.rhtml" do
  include AccountsHelper
  
  before do
    @account = mock_model(Account)

    assigns[:account] = @account
  end

  it "should render attributes in <p>" do
    render "/accounts/show.rhtml"

  end
end

