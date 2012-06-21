# -*- encoding : utf-8 -*-
class CreateEventLines < ActiveRecord::Migration
  def self.up
    create_table :event_lines do |t|
      foreign_key		:event, :ref => true
      foreign_key		:account, :ref => true
      decimal				:amount
    end
  end

  def self.down
    drop_table :event_lines
  end
end
