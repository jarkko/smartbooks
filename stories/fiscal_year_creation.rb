# -*- encoding : utf-8 -*-
require File.join(File.dirname(__FILE__), "helper")

with_steps_for :fiscal_year do
  run File.expand_path(__FILE__).gsub(".rb",""), :type => RailsStory
end
