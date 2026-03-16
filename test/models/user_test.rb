require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  # setup account cloning verification
  def setup
    @user = User.new(name: "Example User", email: "user@example.com", password: "password123", password_confirmation: "password123")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "           "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "       "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "should follow and unfollow a user" do
    tuanle = users(:tuanle)
    archer = users(:archer)
    assert_not tuanle.following?(archer)
    tuanle.follow(archer)
    assert tuanle.following?(archer)
    assert archer.followers.include?(tuanle)
    tuanle.unfollow(archer)
    assert_not tuanle.following?(archer)
  end

  test "feed should have the right posts" do
    tuanle = users(:tuanle)
    archer = users(:archer)
    lana = users(:lana)

    lana.microposts.each do |post_following|
      assert tuanle.feed.include?(post_following)
    end

    tuanle.microposts.each do |post_self|
      assert tuanle.feed.include?(post_self)
    end
    archer.microposts.each do |post_unfollowed|
      assert_not tuanle.feed.include?(post_unfollowed)
    end
  end
end
