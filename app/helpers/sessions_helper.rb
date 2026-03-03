module SessionsHelper
  # create sesstion
  def log_in(user)
    session[:user_id] = user.id
  end

  # remember Id user
  def remember(user)
    # call function remember in Model User
    user.remember

    # Put a id user on cookie
    cookies.permanent.encrypted[:user_id] = user.id

    # put a token on cookie
    cookies.permanent[:remember_token] = user.remember_token
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

  # delete sesssion
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # the user is translate
  def current_user
    if (user_id = session[:user_id])
      # check user is pending
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.encrypted[:user_id])
      # has the browser returned ?
      user = User.find_by(id: user_id)

      # check the token has a user!

      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end

    #check if the token is deleted

  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def current_user?(user)
    user && user == current_user
  end
end
