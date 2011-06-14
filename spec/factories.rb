# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                  "Gordon Moon"
  user.email                 "webmaster@sidewayslogic.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end
# Added 5/31/2011 for testing pagination
Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

# Added 6/12/2011 for testing ads
Factory.define :ad do |ad|
  ad.description "Foo bar"
  ad.association :user
end