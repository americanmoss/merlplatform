class User < ActiveRecord::Base

	devise :database_authenticatable, :registerable,
		:recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:linkedin]

	extend FriendlyId
	friendly_id :name, use: :slugged

	belongs_to :industry
	has_and_belongs_to_many :skills
	has_and_belongs_to_many :commitments
	has_and_belongs_to_many :achievements

	has_many :positions
	has_many :educations

	validates :industry_id, :skill_ids, presence: true

	enum user_type: {
		entrepreneur: 0,
		merl_member: 1,
		merl_ambassador: 2,
		merl_executive: 3
	}

	enum user_status: {
		inactive: 0,
		signup_finished: 1,
		hidden: 2,
		administrator: 3
	}

	def self.from_omniauth(auth ,params)
		where(auth.slice(:provider, :uid)).first_or_create do |user|
			user.provider = auth.provider
			user.uid = auth.uid
			user.email = auth.info.email
			user.name = auth.info.name
			user.password = Devise.friendly_token[10,20]
			user.first_name = auth.info.first_name
			user.last_name = auth.info.last_name
			user.headline = auth.info.description
			user.linkedin_industry = auth.extra.raw_info.industry	
			user.linkedin_image_url = auth.info.image
			user.linkedin_profile_url = auth.extra.raw_info.publicProfileUrl

			# Need to figure out if there is a way to pass this through as an integer, or if casting is necessary to deal with the fact that the parameter is pulled from the callback URL
			user.user_type = params["user_type"].to_f if params
		end
	end

	 def save_linkedin_token(token)
		self.linkedin_token = token
		self.save
	end

	def pull_linkedin_info
		api = LinkedIn::API.new(linkedin_token)
		self.linkedin_image_url = api.picture_urls.all.first

		# Commented out for now, as may not be entirely necessary
		# self.pull_skills(api)

		self.pull_positions(api)
		self.pull_educations(api)
	end

	def pull_positions(api)
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
	end

	def pull_skills(api)
		api.profile(fields:[{skills: ['skill']}]).to_hash['skills']['all'].each do |skill|
			new_skill = Skill.find_or_create_by( skill: skill['skill']['name'])
			self.skills << new_skill
			self.save
		end
	end

	def pull_educations(api)
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
	end

	def string_user_type
		case self[:user_type]
		when 0
			"Entrepreneur"
		when 1
			"MERL Member"
		when 2
			"MERL Ambassador"
		end
	end

	def symbol_user_type
		case self[:user_type]
		when 0
			"E"
		when 1
			"M"
		when 2
			"A"
		end
	end

	private

	def linkedin_client
		@client ||= LinkedIn::Client.new(ENV["LINKEDIN_KEY"], ENV["LINKEDIN_SECRET"])
		block_given? ? yield(@client) : @client
	end
end
