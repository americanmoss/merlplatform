# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


File.readlines(Rails.root.join('db', 'industries.txt')).each do |industry|
  Industry.create(
    name: industry.strip
  )
end

File.readlines(Rails.root.join('db', 'skills.txt')).each do |skill|
  Skill.create(
    name: skill.strip
  )
end

File.readlines(Rails.root.join('db', 'achievements.txt')).each do |achievement|
  name, description = achievement.split('|')
  Achievement.create(
    name: name.strip,
    description: description.try(:strip)
  )
end

File.readlines(Rails.root.join('db', 'commitments.txt')).each do |commitment|
  name, description = commitment.split('|')
  Commitment.create(
    name: name.strip,
    description: description.try(:strip)
  )
end



# File.readlines(Rails.root.join('db', 'regions.txt')).each do |region|
#   Region.create(
#     name: region.strip
#   )
# end