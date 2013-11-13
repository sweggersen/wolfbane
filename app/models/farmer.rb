class Farmer < ActiveRecord::Base
  has_many :sheep, dependent: :destroy
  before_create :create_remember_token
  before_save {
    self.email = email.downcase
    self.backup = backup.downcase if self.backup
  }
  validates :name, presence: true, length: { maximum: 50 }
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  PHONE_REGEX = /\A\+47[0-9]{8}\z/
  validates :email, presence:   true,
                    format:     { with: EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :phone, presence:true,
                    format: { with: PHONE_REGEX }
  has_secure_password
  validates :password, length: { minimum: 8 }, if: :password_changed?
  validate :valid_backup

  attr_accessor :current_sheep

  def valid_backup
    if not (self.backup.nil? || self.backup.blank? || Farmer.find_by_email(backup))
      errors.add(:backup, 'no such email registrated')
    end
  end

  def Farmer.new_remember_token
      SecureRandom.urlsafe_base64
  end

  def Farmer.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private
    def create_remember_token
      self.remember_token = Farmer.encrypt(Farmer.new_remember_token)
    end
    def password_changed?
      !@password.blank?# or encrypted_password.blank?
    end
end
