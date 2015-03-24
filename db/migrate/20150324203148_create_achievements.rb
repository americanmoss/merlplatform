class CreateAchievements < ActiveRecord::Migration
  def change
    create_table :achievements do |t|
      t.string :name
      t.text :description

      t.timestamps
    end

    create_table :achievements_users, id: false do |t|
     t.belongs_to :user, index: true
     t.belongs_to :achievement, index: true
    end

  end
end
