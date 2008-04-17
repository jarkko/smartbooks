require File.dirname(__FILE__) + '/../spec_helper'

describe BalanceSheetsController do

  #Delete these examples and add some real ones
  it "should use BalanceSheetController" do
    controller.should be_an_instance_of(BalanceSheetController)
  end


  describe "GET 'show'" do
    it "should be successful" do
      get 'show'
      response.should be_success
    end
  end
end
