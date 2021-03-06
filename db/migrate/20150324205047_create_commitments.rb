class CreateCommitments < ActiveRecord::Migration
  def change
    create_table :commitments do |t|
      t.string :name
      t.text :description

      t.timestamps
    end

    create_table :commitments_users, id: false do |t|
     t.belongs_to :user, index: true
     t.belongs_to :commitment, index: true
    end

  end
end
