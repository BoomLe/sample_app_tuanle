class UsersController < ApplicationController
  # add_flash_types :info, :error, :warning, :success
  def show
    @user = User.find(params[:id])
  end

  def new
    # create from to view
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user, success: "Welcome to the Sample App!", status: :see_other
    else
      render "new", status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
