class AddSignupCompleteToUsers < ActiveRecord::Migration
  def change
    add_column :users, :signup_complete, :boolean, default:false
  end
end
