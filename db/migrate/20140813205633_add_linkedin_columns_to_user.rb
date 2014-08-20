class AddLinkedinColumnsToUser < ActiveRecord::Migration
  def change
  	add_column :users, :first_name, :string
  	add_column :users, :last_name, :string
  	add_column :users, :headline, :string
  	add_column :users, :industry, :string
  	add_column :users, :linkedin_profile_url, :string
  	add_column :users, :linkedin_image_url, :string
  end
end
