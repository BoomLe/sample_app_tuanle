require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "valid signup information with account activation" do
    get signup_path

    assert_difference "User.count", 1 do
      post users_path, params: { user: { name: "Example User",
                                        email: "user@example.com",
                                        password: "password",
                                        password_confirmation: "password" } }
    end

    # check to send email
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    log_in_as(user)
    assert_not logged_in?
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not logged_in?
    get edit_account_activation_path(user.activation_token, email: user.email)

    # result email
    assert user.reload.activated?
    follow_redirect!
    assert_template "users/show"
    assert logged_in?
  end
end
