class AddCompanyFieldsToPosition < ActiveRecord::Migration
  def change
  	add_column :positions, :company_url, :string	
  	add_column :positions, :company_square_logo_url, :string
  end
end
