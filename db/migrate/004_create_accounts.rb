# -*- encoding : utf-8 -*-
class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string		  :title
      t.text		    :description
      t.datetime		:created_at
      t.datetime		:updated_at
      t.integer		  :parent_id
      t.string		  :vat_type
      t.decimal		  :vat_percent
      t.string		  :account_number
      t.integer     :fiscal_year_id
      t.foreign_key :fiscal_years
      
      t.timestamps
    end
    
    add_index :accounts, [:parent_id, :account_number]
  end

  def self.down
    drop_table :accounts
  end
end
