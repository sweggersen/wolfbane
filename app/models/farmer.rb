# Farmer class, inherits ActiveRecord::Base which handles the database interaction.
class Farmer < ActiveRecord::Base
  # Sets up a one-to-many relation with sheep, and deletes all
  # owned sheep upon deletion of farmer
  has_many :sheep, dependent: :destroy
  before_create :create_remember_token
  # downcase email address of farmer and backup before saving in database
  before_save {
    self.email = email.downcase
    self.backup = backup.downcase if self.backup
  }
  # Require presence of name in the sign-up form, with a maximum length of 50 characters.
  validates :name, presence: true, length: { maximum: 50 }
  # Regexes for valid email and phone format
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # +47 and 8 digits
  PHONE_REGEX = /\A\+47[0-9]{8}\z/
  validates :email, presence:   true,
                    format:     { with: EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :phone, presence:true,
                    format: { with: PHONE_REGEX }
  # Hashing of password with salt
  has_secure_password
  # Ensure a password of minimum 8 chacaters of length
  validates :password, length: { minimum: 8 }, if: :password_changed?
  # Validate a specified backup's email address using the valid_backup method
  validate :valid_backup

  attr_accessor :current_sheep

  # Ensures that the specified backup email is, if present, a user registered
  # in the system.
  def valid_backup
    if not (self.backup.nil? || self.backup.blank? || Farmer.find_by_email(backup))
      errors.add(:backup, 'Ingen avløser med den eposten registrert')
    end
  end

  # Creates a cookie to store login
  def Farmer.new_remember_token
      SecureRandom.urlsafe_base64
  end

  # Convenience method for encrypting a remember token
  def Farmer.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private
    def create_remember_token
      self.remember_token = Farmer.encrypt(Farmer.new_remember_token)
    end
    # When editing a user, only require password if the password has changed
    def password_changed?
      !@password.blank?
    end
end
