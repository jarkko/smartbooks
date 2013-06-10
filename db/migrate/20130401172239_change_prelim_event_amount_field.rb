class ChangePrelimEventAmountField < ActiveRecord::Migration
  def up
    change_table :preliminary_events do |t|
      t.rename :amount, :amount_cents
    end
  end

  def down
  end
end
