class User < ActiveRecord::Base
	has_many :microposts
	has_secure_password

	validates :name, presence: true, length:{maximum:50}
	valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length:{maximum: 255},
					  format: {with: valid_email_regex},
					  uniqueness: true
	validates :password, length: { minimum: 6 }
end
