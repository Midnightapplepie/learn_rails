module SessionsHelper
	def log_in(user)
	    session[:user_id] = user.id
	end

	def current_user?(user)
	    user == current_user
	end

	def current_user
	   # check session for user_id, if nil, check cookies for id and token
	  if session[:user_id]
	    @current_user ||= User.find_by(id: session[:user_id])
	  elsif cookies.signed[:user_id]
	    user = User.find_by(id: cookies.signed[:user_id])
	    if user && user.authenticated?(cookies[:remember_token])
	      log_in user
	      @current_user = user
	    end
	  end
	end

	# Returns true if the user is logged in, false otherwise.
	  def logged_in?
	    !current_user.nil?
	  end

	  #user logging out, clearing cookies 
	  def forget(user)
	      user.forget
	      cookies.delete(:user_id)
	      cookies.delete(:remember_token)
	  end

	  def log_out
	  	  forget(current_user)
	      session.delete(:user_id)
	      @current_user = nil
	  end

	def remember(user)
		user.remember
		#cookies.permanent.signed is secured way for storing data in user cookies
		#signed mean encrypt
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

	# the purpose of 2 methods below is to send none-logged in user to where they 
	#wanted to geo after login instead of always their user page
	
	# Redirects to stored location (or to the default)
	def redirect_back_or(default)
	  redirect_to(session[:forwarding_url] || default)
	  session.delete(:forwarding_url)
	end

	# Stores the URL trying to be accessed.
	def store_location
      #store url requested, that user is going to 
	  session[:forwarding_url] = request.url if request.get?
	end
end
