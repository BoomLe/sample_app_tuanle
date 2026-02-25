module SessionsHelper
  # create sesstion
  def log_in(user)
    session[:user_id] = user.id
  end

  # show username
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # return true if user login
  def logged_in?
    !current_user.nil?
  end
end

# delete sesssion
def log_out
  session.delete(:user_id)
  @current_user = nil
end
