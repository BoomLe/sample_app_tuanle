class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  #create a bag take var (token)
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
  #create a bag to take a token
  attr_accessor :remember_token
  #lowcase email
  before_save { self.email = email.downcase }
  #check username
  validates :name, presence: true, length: { maximum: 50 }
  #check email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  # Hash password
  has_secure_password

  # hash(Bcrypt)
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # create a token
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # remember user
  def remember

    # puts Id
    self.remember_token = User.new_token

    # create a bag take a hash
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    # if the user is not be allowed it would have exited
    return false if digest.nil?

    # check BCrypt combination with a hash
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  # active user
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # send email active
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # create key password save to database
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # call mailler recovery to mail
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  #check if the time less than 2 hours
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships
                        WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id).includes(:user, image_attachment: :blob)
  end

  #follow user
  def follow(other_user)
    following << other_user
  end

  #unfollow user
  def unfollow(other_user)
    following.delete(other_user)
  end

  # check the follower count
  def following?(other_user)
    following.include?(other_user)
  end

  def self.search(query)
    if query.present?
      where("name ILIKE ?", "%#{query}%")
    else 
      all 
    end
  end

  private

  # conver an email to lowcase
  def downcase_email
    self.email = email.downcase
  end

  #create and hash (active)
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
