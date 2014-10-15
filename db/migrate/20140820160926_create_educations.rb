class CreateEducations < ActiveRecord::Migration
  def change
    create_table :educations do |t|
      t.string :school_name
      t.string :degree
      t.string :field_of_study
      t.integer :linkedin_education_id
      t.datetime :start_date
      t.datetime :end_date
      	
      t.timestamps
    end
  end
end
