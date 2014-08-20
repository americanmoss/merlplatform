class AddMerlMemberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :merl_member, :boolean, default: nil
  end
end
