class User < ApplicationRecord
  before_save :downcase_email

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :name,  presence: true, length: {maximum: Settings.max_lenght_name}
  validates :email, presence: true, length: {maximum: Settings.max_lenght_email},
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: Settings.max_lenght_password}

  has_secure_password

  private

  def downcase_email
    email.downcase!
  end

end
