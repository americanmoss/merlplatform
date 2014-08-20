class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|

      t.string :name
      t.integer :company_id
      t.string :industry
      t.string :title
      t.text :summary
      t.boolean :is_current
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
