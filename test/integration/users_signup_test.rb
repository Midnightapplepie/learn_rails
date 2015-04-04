require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'invalid creation' do
  	before_count = User.count
  	

  	post users_path, user: { name:  "",
                           email: "user@invalid",
                           password:              "foo",
                           password_confirmation: "bar" }

  	after_count  = User.count
  	assert_equal before_count, after_count

  	assert_template 'users/new'
  end

  test 'valid creation' do
  	get signup_path
  	before_count = User.count
  	
  	post users_path, user: { name:  "Real",
                           email: "user@valid.com",
                           password:              "1234567",
                           password_confirmation: "1234567" }

  	after_count  = User.count
  	assert_not_equal before_count, after_count

  	follow_redirect!
  	assert_template 'users/show'
  end
end
