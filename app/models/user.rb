class User < ApplicationRecord

  include ActiveModel::SecurePassword
  has_secure_password

  ## VALIDATIONS ##
  validates :name, :email, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, allow_blank: true },
                    uniqueness: { allow_blank: true }

  ## ASSOCIATIONS ##
  has_many :clients

  ## CONSTANTS ##
  enum role: {
    controller: 0,
    risk_manager: 1,
    admin: 2
  }

  ## INSTANCE METHODS ##
  def formatted_role
    role.titleize
  end

end
