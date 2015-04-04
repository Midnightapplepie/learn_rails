class UsersController < ApplicationController
  #call this method before edit and update action
  #these are action that will reroute user if condition met. privacy/ownership control
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
      @users = User.paginate(page: params[:page])
  end
  
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

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash.now[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
      User.find(params[:id]).destroy
      flash[:success] = "User deleted"
      redirect_to users_url
  end

  private
  def logged_in_user
        unless logged_in?
          store_location
          flash[:danger] = "Please log in."
          redirect_to login_url
        end
  end

  def correct_user
        @user = User.find(params[:id])
        redirect_to(root_url) unless current_user?(@user)
  end


    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    #check before destroy action and make sure it's admin
    def admin_user
          redirect_to(root_url) unless current_user.admin?
    end
end
