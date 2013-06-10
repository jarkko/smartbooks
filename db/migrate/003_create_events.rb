# -*- encoding : utf-8 -*-
class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer         :fiscal_year_id
      t.foreign_key     :fiscal_years
      t.integer         :receipt_number
      t.date            :event_date
      t.text            :description
      
      t.timestamps
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
