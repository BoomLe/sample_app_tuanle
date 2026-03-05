require "test_helper"

class PasswordResetsTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:tuanle)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template "password_resets/new"
    assert_select "input[name=?]", "password_reset[email]"

    # check wrong email
    post password_resets_path, params: { password_reset: { email: "" } }
    assert_not flash.empty?
    assert_template "password_resets/new"

    # check the valid email
    post password_resets_path, params: { password_reset: { email: @user.email } }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url

    # take token
    user = assigns(:user)

    # the email is wrong please check a link
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url

    # tried to access the link but recevied an "invalid token" error
    get edit_password_reset_path("wrong token", email: user.email)
    assert_redirected_to root_url

    # click the link
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template "password_resets/edit"
    assert_select "input[name=email][type=hidden][value=?]", user.email

    # wrong password
    patch password_reset_path(user.reset_token),
          params: { email: user.email, user: { password: "foobaz", password_confirmation: "barquux" } }
    assert_select "div#error_explanation"

    # password empty
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password: "", password_confirmation: "" } }
    assert_select "div#error_explanation"

    # correct password
    patch password_reset_path(user.reset_token),
          params: { email: user.email, user: { password: "foobaz", password_confirmation: "foobaz" } }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user

    assert_nil user.reload.reset_digest
  end
end
