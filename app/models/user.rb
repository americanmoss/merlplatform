class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable 
	devise :database_authenticatable, :registerable,
		:recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:linkedin]

	extend FriendlyId
	friendly_id :name, use: :slugged

	has_many :positions
	has_many :educations
	has_many :skills

	def self.from_omniauth(auth)
		where(auth.slice(:provider, :uid)).first_or_create do |user|
			user.provider = auth.provider
			user.uid = auth.uid
			user.email = auth.info.email
			user.name = auth.info.name
			user.password = Devise.friendly_token[10,20]
			user.first_name = auth.info.first_name
			user.last_name = auth.info.last_name
			user.headline = auth.info.description
			user.industry = auth.extra.raw_info.industry	
			user.linkedin_image_url = auth.info.image
			user.linkedin_profile_url = auth.extra.raw_info.publicProfileUrl
		end
	end

	 def save_linkedin_token(token)
		self.linkedin_token = token
		self.save
	end

	def signup_finished?
		!self.merl_member.nil? && self.signup_complete
	end

	def pull_linkedin_info
		api = LinkedIn::API.new(linkedin_token)
		self.linkedin_image_url = api.picture_urls.all.first

		# Positions
		api.profile(fields:[{positions: ['id', 'title', 'summary', 'is_current', 'start_date', 'end_date', 'company']}]).to_hash['positions']['all'].each do |position|
			
			new_position = Position.find_or_create_by(linkedin_position_id: position['id']) do |user_position|
			           user_position.title = position['title']
			           user_position.summary = position['summary']
			           user_position.is_current = position['is_current']
			           user_position.start_date = position['start_date']
			           user_position.end_date = position['end_date']

			           user_position.name = position['company']['name']
			           user_position.company_id = position['company']['id']
			           user_position.industry = position['company']['industry']

			           if  position['company']['id']
				           company_api = api.company(id: position['company']['id'], fields:['website_url', 'logo_url', 'square_logo_url']).to_hash
					user_position.company_url = company_api['website_url']
					user_position.company_logo_url = company_api['logo_url']
					user_position.company_square_logo_url = company_api['square_logo_url']
				end
			end
			self.positions << new_position
          			self.save
		end

		# Educations
		api.profile(fields:[{educations: ['id', 'school_name', 'field_of_study', 'degree', 'start_date', 'end_date']}]).to_hash['educations']['all'].each do |education|

			new_education = Education.find_or_create_by(linkedin_education_id: education['id']) do |user_education|
				user_education.school_name = education['school_name']
				user_education.field_of_study = education['field_of_study']
				user_education.degree = education['degree']
				user_education.start_date = education['start_date']
				user_education.end_date = education['end_date']
			end
			
			self.educations << new_education
			self.save
		end

		# Skills 
		api.profile(fields:[{skills: ['skill']}]).to_hash['skills']['all'].each do |skill|
			new_skill = Skill.find_or_create_by( skill: skill['skill']['name'])
			self.skills << new_skill
			self.save
		end

	end

	def linkedin_client
		@client ||= LinkedIn::Client.new(ENV["LINKEDIN_KEY"], ENV["LINKEDIN_SECRET"])
		block_given? ? yield(@client) : @client
	end
end
