# -*- encoding : utf-8 -*-
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def colored_sum(sum)
    content_tag(:span, sum, :class => "event_line_amount " + (sum.to_f > 0 ? "positive" : "negative"))
  end
  
  def trimmed(amnt)
    amnt.to_s.gsub(/\.0*$/, "")
  end
  
  def month_select_tag(selected = nil)
    select_tag("month", options_for_select(MONTHS, selected))
  end
  
  def formatted(amount)
    sprintf("%.2f", amount.to_i / 100.0)
  end
end
