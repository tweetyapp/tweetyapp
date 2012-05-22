require 'faker'

namespace :db do
	desc "Fill database with sample data"
	task :populate => :environment do
		Rake::Task['db:reset'].invoke
		admin = User.create!(:name => "Arun",
					:email => "arun@yahoo.com",
					:password => "foobar",
					:password_confirmation => "foobar")
		admin.toggle!(:admin)
		99.times do |n|
			name = Faker::Name.name
			email_id = ('a'..'z').to_a.shuffle[0..4].join
			email = "#{name.split(' ')[0]}#{n+1}@yahoo.com"
			password = "password"
			User.create!(:name => name,
						:email => email,
						:password => password,
						:password_confirmation => password)
		end
	end
end
