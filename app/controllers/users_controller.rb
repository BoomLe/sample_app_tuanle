class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  # add_flash_types :info, :error, :warning, :success

  def index
    @users = User.search(params[:query]).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])

    #include all the contents to user
    #paginate to the contents
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    # create from to view
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # call function email
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url, status: :see_other
    else
      render "new", status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render "edit", status: :unprocessable_entity
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url, status: :see_other
  end

  def following
    @title = "Following"
    @user = User.find(params[:"id"])
    @users = @user.following.paginate(page: params[:page])
    render "show_follow"
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  #check a validation user
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url, status: :see_other
    end
  end

  # Is the user validated?
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url, status: :see_other) unless current_user?(@user)
  end

  #check admin
  def admin_user
    redirect_to(root_url, status: :see_other) unless current_user.admin?
  end
end
