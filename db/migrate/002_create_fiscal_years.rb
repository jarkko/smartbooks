# -*- encoding : utf-8 -*-
class CreateFiscalYears < ActiveRecord::Migration
  def self.up
    create_table :fiscal_years do |t|
      t.text        :description
      t.date        :start_date
      t.date        :end_date
      t.integer     :company_id
      
      t.timestamps
    end
    
    add_index :fiscal_years, :start_date
  end

  def self.down
    remove_index :fiscal_years, :start_date
    drop_table :fiscal_years
  end
end
