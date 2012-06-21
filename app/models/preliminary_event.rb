# -*- encoding : utf-8 -*-
class PreliminaryEvent < ActiveRecord::Base
  attr_accessible :account_id, :account_number, :amount, :bic, :booking_date, :card_number, :counterpart, :description, :message, :payer_reference, :payment_date, :receipt, :reference, :value_date
end
