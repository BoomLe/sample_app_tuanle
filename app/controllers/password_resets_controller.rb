class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    # search to email has exists
    @user = User.find_by(email: params[:password_reset][:email].downcase)

    if @user
      # call two function into model => create key => send mail
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      # not found
      flash.now[:danger] = "Email not found"
      render "new", status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      #check to empty user and password
      @user.errors.add(:password, "can't be empty")
      render "edit", status: :unprocessable_entity
    elsif @user.update(user_params)
      # change to password succeed
      reset_session
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset"
      redirect_to @user
    else
      render "edit", status: :unprocessable_entity
    end
  end

  private

  #allowed to parameters through
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # take to infomation user and email on url
  def get_user
    @user = User.find_by(email: params[:email])
  end

  #check User valid to activation and token
  def valid_user
    unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
      redirect_to root_url
    end
  end

  #check to the users
  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expored."
      redirect_to new_password_reset_url
    end
  end
end
