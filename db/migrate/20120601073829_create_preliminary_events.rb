# -*- encoding : utf-8 -*-
class CreatePreliminaryEvents < ActiveRecord::Migration
  def change
    create_table :preliminary_events do |t|
      t.integer :account_id, :null => false
      t.integer :fiscal_year_id, :null => false
      t.integer :amount, :limit => 10, :precision => 10, :scale => 0, :null => false, :default => 0
      t.date :booking_date, :null => false
      t.date :value_date
      t.date :payment_date
      t.string :counterpart
      t.string :account_number
      t.string :bic
      t.text :description
      t.string :reference
      t.string :payer_reference
      t.text :message
      t.string :card_number
      t.text :receipt
      t.boolean :booked, :null => false, :default => false

      t.timestamps
    end

    add_index :preliminary_events, [:account_id, :booking_date]
    add_index :preliminary_events, [:fiscal_year_id, :booking_date]
  end
end
