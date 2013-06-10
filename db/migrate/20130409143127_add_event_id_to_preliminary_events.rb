class AddEventIdToPreliminaryEvents < ActiveRecord::Migration
  def change
    change_table :preliminary_events do |t|
      t.integer :event_id
      t.index :event_id
      t.remove :booked
    end
  end
end
