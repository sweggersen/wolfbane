class Farmer < ActiveRecord::Base
  has_many :sheep
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 8 }
end
