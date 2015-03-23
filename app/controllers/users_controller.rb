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


	# Edit after successful implementation of Wicked
	def finish_signup
		if request.patch? && params[:user]
			if @user.update(user_params)
				sign_in(@user == current_user ? @user : current_user, :bypass => true)
				redirect_to @user, success: 'Your profile was successfully created.'
			else
				render action: 'edit'
			end
      	end
    	end

end
