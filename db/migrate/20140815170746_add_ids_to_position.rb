class AddIdsToPosition < ActiveRecord::Migration
  def change
  	add_column :positions, :linkedin_position_id, :integer
  	add_column :positions, :user_id, :integer
  end
end
