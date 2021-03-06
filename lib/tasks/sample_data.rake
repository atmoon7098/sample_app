namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:name => "Gordon Moon",
                         :email => "webmaster@sidewayslogic.com",
                         :password => "foobar",
                         :password_confirmation => "foobar")
	admin.toggle!(:admin)
	
    49.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(:name => name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    end
	User.all(:limit => 6).each do |user|
      15.times do
        user.ads.create!(:description => Faker::Lorem.sentence(5))
      end
    end
	
  end
end