class MakeReceiptNumberBig < ActiveRecord::Migration
  def change
    change_column :events, :receipt_number, :string
  end
end