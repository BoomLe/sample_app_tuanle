class SessionsController < ApplicationController
  def new
  end

  def create
    # checking users in the database
    user = User.find_by(email: params[:session][:email].downcase)

    # checking if user exists and validating the password
    if user && user.authenticate(params[:session][:password])

      if user.activated?
      #validating the user and password
      log_in user

      #remember user
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      redirect_to user
      else
        message = "Account not activated."
        message += "check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    
      
    else
      flash.now[:danger] = "Invalid email/password combination"
      render "new", status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    #logout user
    redirect_to root_url, status: :see_other
  end
end
