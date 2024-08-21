class AdminUser < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :loans
  validates :email, presence: true, format: { with: Devise.email_regexp, allow_blank: true }, if: :email_changed?
  validates :password, presence: true, length: { within: Devise.password_length }, allow_blank: true

  validates :first_name, :last_name, presence: true
end
