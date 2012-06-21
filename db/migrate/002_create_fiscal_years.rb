# -*- encoding : utf-8 -*-
class CreateFiscalYears < ActiveRecord::Migration
  def self.up
    create_table :fiscal_years do |t|
      text        :description
      date        :start_date
      date        :end_date
      integer     :company_id
      
      timestamps!
    end
    
    add_index :fiscal_years, :start_date
  end

  def self.down
    remove_index :fiscal_years, :start_date
    drop_table :fiscal_years
  end
end
