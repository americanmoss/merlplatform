class FixColumnName < ActiveRecord::Migration
  def change
   rename_column :users, :industry, :linkedin_industry
  end
end
