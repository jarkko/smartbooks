# -*- encoding : utf-8 -*-
class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      string		  :title
      text		    :description
      datetime		:created_at
      datetime		:updated_at
      integer		  :parent_id
      string		  :vat_type
      decimal		  :vat_percent
      string		  :account_number
      foreign_key :fiscal_year, :ref => true
      
      timestamps!
    end
    
    add_index :accounts, [:parent_id, :account_number]
  end

  def self.down
    drop_table :accounts
  end
end
