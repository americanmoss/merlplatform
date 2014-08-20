class OmniauthCallbacksController < Devise::OmniauthCallbacksController

	def linkedin
		@user = User.from_omniauth(request.env["omniauth.auth"])
		temp_token = request.env["omniauth.auth"].credentials.token
		safe_url = URI.parse(URI.encode("#{root_url}users/auth/linkedin/callback"))
		temp = params[:code]
		response = HTTParty.post("https://www.linkedin.com/uas/oauth2/accessToken?grant_type=authorization_code&code=#{temp}&redirect_uri=#{safe_url}&client_id=#{ENV['LINKEDIN_KEY']}&client_secret=#{ENV['LINKEDIN_SECRET']}")
		expiry = response['expires_in']
    		@user.save_linkedin_token(response['access_token'])

		if @user.persisted?
			@user.pull_linkedin_info
			sign_in_and_redirect @user, :event => :authentication
			flash[:success] = "Welcome, #{@user.name}"
		else
			session["devise.linkedin"] = request.env["omniauth.auth"]
			redirect_to root_url
		end
	end

	def after_sign_in_path_for(resource)
		if resource.signup_finished?
			super resource
		else
			finish_signup_path(resource)
		end
	end
end
