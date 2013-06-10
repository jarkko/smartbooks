 # -*- encoding : utf-8 -*-
class PreliminaryEvent < ActiveRecord::Base
  attr_accessible :account_id, :account_number, :amount, :bic, :booking_date, :card_number, :counterpart, :description, :message, :payer_reference, :payment_date, :receipt, :reference, :value_date

  belongs_to :account
  belongs_to :fiscal_year

  monetize :amount_cents

  def self.from_nordea_line(line)
    return nil if line.blank?
    line = line.split("\t")
    new({
      :booking_date => Date.parse(line[0]),
      :value_date => Date.parse(line[1]),
      :payment_date => Date.parse(line[2]),
      :amount => line[3], # automatically monetized
      :counterpart => line[4],
      :account_number => line[5],
      :bic => line[6],
      :description => line[7],
      :reference => line[8],
      :payer_reference => line[9],
      :message => line[10],
      :card_number => line[11],
      :receipt => line[12]
    })
  end
end
