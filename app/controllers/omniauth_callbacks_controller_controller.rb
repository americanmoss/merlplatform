class OmniauthCallbacksControllerController < Devise::OmniauthCallbacksController

	def linkedin
		@user = User.from_omniauth(request.env["omniauth.auth"])
		temp_token = request.env["omniauth.auth"].credentials.token
		safe_url = URI.parse(URI.encode("#{root_url}users/auth/linkedin/callback"))
		response = HTTParty.post("https://www.linkedin.com/uas/oauth2/accessToken?grant_type=authorization_code&code=#{temp}&redirect_uri=#{safe_url}&client_id=#{ENV['LINKEDIN_KEY']}&client_secret=#{ENV['LINKEDIN_SECRET']}")
		expiry = response['expires_in']
    		@user.save_linkedin_token(response['access_token'])

		if @user.persisted?
			sign_in_and_redirect root_url, :event => :authentication
		else
			session["devise.linkedin"] = request.env["omniauth.auth"]
			redirect_to new_user_registration_url
		end
	end

end
