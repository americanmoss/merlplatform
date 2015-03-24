class UsersController < ApplicationController
	before_action :authenticate_user!, except: [:index, :show]

	def show
		@user = current_user
		@profile = User.friendly.find(params[:id])
	end

	def index
		@user = current_user
		@users = User.where("user_type <> ?", User.user_types[:entrepreneur])
	end

end
