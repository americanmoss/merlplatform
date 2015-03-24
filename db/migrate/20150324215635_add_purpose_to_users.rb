class AddPurposeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :purpose, :text
  end
end
