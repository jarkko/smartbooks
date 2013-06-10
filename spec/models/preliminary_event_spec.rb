# -*- encoding : utf-8 -*-
require "spec_helper"

describe PreliminaryEvent do
  describe "from_nordea_line" do
    @expected = {
      booking_date: Date.new(2012,5,4),
      value_date: Date.new(2012,5,5),
      payment_date: Date.new(2012,5,6),
      amount: Money.new(-490, "EUR"),
      counterpart: "NORDEA PANKKI SUOMI OYJ",
      account_number: "",
      bic: "",
      description: "Palvelumaksu",
      reference: "1.04.-30.04.2012",
      payer_reference: "",
      message: "Konttoripalvelut 116630-203010 Tiliotteet                       *)       1 kpl a'   2,500 e       2,50 Maksut pankkitunnuksilla         *)       6 kpl a'   0,400 e       2,40 *) alv rek. 0% ",
      card_number: "123  ",
      receipt: "nope"
    }

    before(:each) do
      @line = %[04.05.2012	05.05.2012	06.05.2012	-4,90	NORDEA PANKKI SUOMI OYJ			Palvelumaksu	1.04.-30.04.2012		Konttoripalvelut 116630-203010 Tiliotteet                       *)       1 kpl a'   2,500 e       2,50 Maksut pankkitunnuksilla         *)       6 kpl a'   0,400 e       2,40 *) alv rek. 0% 	123  	nope	]
      @event = PreliminaryEvent.from_nordea_line(@line)
    end

    @expected.each do |key, val|
      it "should get correct #{key.to_s.humanize}" do
        @event.send(key).should == val
      end
    end

  end
end