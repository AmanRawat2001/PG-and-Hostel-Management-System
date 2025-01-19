require "bcrypt"

class User < ApplicationRecord
  attr_accessor :password, :password_confirmation
  
  has_many :bookings

  before_save :encrypt_password
  
  validates :password, presence: true, confirmation: true, if: :password_required?, length: { minimum: 8 }
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

  enum role: { admin: 1, resident: 2 }, _prefix: :role
  validates :role, presence: true


  def authenticate(password)
    BCrypt::Password.new(encrypted_password) == password
  end

  private

  def encrypt_password
    if password.present?
      self.encrypted_password = BCrypt::Password.create(password)
    end
  end

  def password_required?
    encrypted_password.blank? || password.present?
  end
end
