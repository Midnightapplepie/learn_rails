class User < ActiveRecord::Base
	attr_accessor :remember_token
	
	has_many :microposts
	has_secure_password

	validates :name, presence: true, length:{maximum:50}
	valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length:{maximum: 255},
					  format: {with: valid_email_regex},
					  uniqueness: true
	validates :password, length: { minimum: 6 }


	# Code from BCrypt source, how they generate hased pw
	  def User.digest(string)
	    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
	                                                  BCrypt::Engine.cost
	    BCrypt::Password.create(string, cost: cost)
	  end

	#generate token to remember user after they close their browser.
	def User.new_token
    	SecureRandom.urlsafe_base64
  	end

  	def remember
  	    self.remember_token = User.new_token
  	    update_attribute(:remember_digest, User.digest(remember_token))
  	end

  	# Forgets a user.
  	  def forget
  	    update_attribute(:remember_digest, nil)
  	  end

  	#checking hashed token stored in cookie match db token for the user:
  	def authenticated?(remember_token)
  		return false if remember_digest.nil?
  	    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  	end
end
