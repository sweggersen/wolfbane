class Farmer < ActiveRecord::Base
  has_many :sheep
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  PHONE_REGEX = /\A\+47[0-9]{8}\z/
  validates :email, presence:   true,
                    format:     { with: EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :phone, presence:true,
                    format: { with: PHONE_REGEX }
  has_secure_password
  validates :password, length: { minimum: 8 }
end
