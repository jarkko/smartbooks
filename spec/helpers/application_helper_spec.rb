# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

describe ApplicationHelper do
  include ApplicationHelper
  
  describe "month_select_tag" do
    it "should show a list of months" do
      month_select_tag.should ==
%{<select id="month" name="month"><option value="1">Tammikuu</option>
<option value="2">Helmikuu</option>
<option value="3">Maaliskuu</option>
<option value="4">Huhtikuu</option>
<option value="5">Toukokuu</option>
<option value="6">Kesäkuu</option>
<option value="7">Heinäkuu</option>
<option value="8">Elokuu</option>
<option value="9">Syyskuu</option>
<option value="10">Lokakuu</option>
<option value="11">Marraskuu</option>
<option value="12">Joulukuu</option></select>}
    end
  end
  
  describe "formatted" do
    it "should show amount as euros" do
      formatted(6900).should == "69.00"
    end
  end
end
