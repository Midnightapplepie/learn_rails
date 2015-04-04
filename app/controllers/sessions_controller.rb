class SessionsController < ApplicationController
  def new
  end

  def create
      user = User.find_by(email: params[:session][:email])
         if user && user.authenticate(params[:session][:password])
           log_in user

           params[:session][:remember_me] == '1' ? remember(user) : forget(user)
           
           redirect_back_or user
         else
           #flash.now create flash message that disappear after new request
           flash.now[:danger] = 'Invalid email/password combination'
           render 'new'
         end
  end

  def destroy
  	#prevent logout if user already logged out
  	log_out if logged_in?
  	redirect_to root_url
  end
end
