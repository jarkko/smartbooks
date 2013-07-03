class AddReceiptToEvents < ActiveRecord::Migration
  def change
    add_column :events, :receipt, :string
  end
end
