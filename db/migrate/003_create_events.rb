# -*- encoding : utf-8 -*-
class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      foreign_key     :fiscal_year, :ref => true
      integer         :receipt_number
      date            :event_date
      text            :description
      
      timestamps!
    end
    
    add_index :events, :event_date
    add_index :events, :receipt_number
  end

  def self.down
    remove_index :events, :event_date
    remove_index :events, :receipt_number
    drop_table :events
  end
end
