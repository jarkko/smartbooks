# -*- encoding : utf-8 -*-
class Account < ActiveRecord::Base
  include ActsAsTree
  acts_as_tree :order => "account_number"
  has_many :event_lines, :dependent => :destroy
  has_many :preliminary_events, :dependent => :nullify
  belongs_to :fiscal_year

  def self.find_virtual
    find_all_by_account_number("-1")
  end

  def self.find_for_dropdown
    where(["account_number <> '-1'"]).
      order("title")
  end

  def print_tree(level = 0)
    puts (" " * level * 2) + self.title + " " +
      result.to_s
    self.children.each do |child|
      child.print_tree(level + 1)
    end
  end

  def all_children
    children + children.map(&:all_children).flatten
  end

  def result
    if account_number == "-1"
      self.children.map{|child| child.result}.sum
    else
      self.event_lines.sum(:amount) || 0
    end
  end

  def total(opts = {})
    lines = event_lines
    if opts[:month]

      if opts[:month].is_a?(Range)
        first = opts[:month].first.to_i
        last = Date.new(fiscal_year.start_date.year, opts[:month].last.to_i, 1)
        end_date = 1.month.since(last).yesterday
      else
        first = opts[:month].to_i
      end

      start_date = Date.new(fiscal_year.start_date.year, first, 1)
      end_date ||= 1.month.since(start_date).yesterday

      lines = lines.joins("join events on event_lines.event_id = events.id").
        where("event_date between '#{start_date.to_s(:db)}' and '#{end_date.to_s(:db)}'")
    end

    if opts[:only]
      operator = opts[:only] == :credit ? "<" : ">"
      condition = "amount #{operator} 0"

      lines = lines.where(condition)
    end

    sum = lines.sum(:amount) || 0

    opts[:formatted] ? sprintf("%+.2f", sum / 100.0) : sum
  end

  def formatted_total(opts = {})
    total(opts.merge(:formatted => true))
  end

  def open_account_from(original)
    fiscal_year.create_event(
      {:event_date => fiscal_year.start_date,
       :description => "Tilinavaus (#{title})"},
      [{:amount => original.total,
        :account => self},
       {:amount => (-1 * original.total),
        :account => fiscal_year.stockholders_equity}]
    )
  end
end
