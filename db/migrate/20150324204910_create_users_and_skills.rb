class CreateUsersAndSkills < ActiveRecord::Migration
  def change
    create_table :skills_users, id: false do |t|
     t.belongs_to :user, index: true
     t.belongs_to :skill, index: true
    end
  end
end
