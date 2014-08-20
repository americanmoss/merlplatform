class AddImageToPosition < ActiveRecord::Migration
  def change
  	add_column :positions, :company_logo_url, :string
  end
end
