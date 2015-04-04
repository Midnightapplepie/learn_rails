class UsersController < ApplicationController

  def show
  	@user = User.find(params[:id])
  	
  	#uncomment the line below to debug at rails server when visit a page
  	#it allow access to all var and method in that route and params
  	# debugger
  end

  def new
  	@user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to user_path @user
      # same as redirect_to @user
    else
      render 'new' 
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
