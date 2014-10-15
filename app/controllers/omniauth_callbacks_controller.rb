class OmniauthCallbacksController < Devise::OmniauthCallbacksController

	def linkedin
		@user = User.from_omniauth(request.env["omniauth.auth"])
		temp_token = request.env["omniauth.auth"].credentials.token
		access_token = OAuth2::AccessToken.new(linkedin_client, temp_token, {
			:mode => :query,
			:param_name => "oauth2_access_token",
		})
		@user.save_linkedin_token(access_token.token)

		# safe_url = URI.parse(URI.encode("#{root_url}users/auth/linkedin/callback"))
		# temp = params[:code]
		# response = HTTParty.post("https://www.linkedin.com/uas/oauth2/accessToken?grant_type=authorization_code&code=#{temp}&redirect_uri=#{safe_url}&client_id=#{ENV['LINKEDIN_KEY']}&client_secret=#{ENV['LINKEDIN_SECRET']}")
		# expiry = response['expires_in']
    		

		if @user.persisted?
			sign_in_and_redirect @user, :event => :authentication
			# @user.pull_linkedin_info
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


	private

	def linkedin_client
		client = OAuth2::Client.new(
			ENV['LINKEDIN_KEY'],
			ENV['LINKEDIN_SECRET'],
			:authorize_url => "/uas/oauth2/authorization?response_type=code", #LinkedIn's authorization path
			:token_url => "/uas/oauth2/accessToken", #LinkedIn's access token path
			:site => "https://www.linkedin.com"
    		)
 	end
end
