# -*- encoding : utf-8 -*-
class CreateEventLines < ActiveRecord::Migration
  def self.up
    create_table :event_lines do |t|
      t.integer         :event_id
      t.foreign_key     :events
      t.integer         :account_id
      t.foreign_key     :accounts
      t.decimal 				:amount
    end
  end

  def self.down
    drop_table :event_lines
  end
end
