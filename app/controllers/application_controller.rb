class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	def after_sign_in_path_for(resource) 
		if current_user.name?
			ensure_signup_complete
			redirect_to user_path(current_user)
		else
			new_user_path
		end
	end

	def toast(type, text)
  		flash[:toastr] = { type => text }
	end

	def ensure_signup_complete
		if current_user && !current_user.signup_finished?
			redirect_to finish_signup_path(current_user)
		end
	end
end
