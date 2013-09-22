class Farmer < ActiveRecord::Base
  has_many :sheep
  before_save {
    self.email = email.downcase
    self.backup = backup.downcase
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
  validates :password, length: { minimum: 8 }
  validate :valid_backup

  def valid_backup
    if not (self.backup.nil? || self.backup.blank? || Farmer.find_by_email(backup))
      errors.add(:backup, 'no such email registrated')
    end
  end
end
