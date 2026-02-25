class SessionsController < ApplicationController
  def new
  end

  def create
    # checking users in the database
    user = User.find_by(email: params[:session][:email].downcase)

    # checking if user exists and validating the password
    if user && user.authenticate(params[:session][:password])
      #validating the user and password
      log_in user
      redirect_to user, status: :see_other
    else
      flash.now[:danger] = "Invalid email/password combination"
      render "new", status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    #logout user
    redirect_to root_url, status: :see_other
  end
end
