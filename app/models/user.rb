class User < ApplicationRecord
    #lowcase email
    before_save {self.email = email.downcase}
    #check username
    validates :name, presence: true, length: {maximum: 50}
    #check email
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}


    # Hash password
    has_secure_password
end
