class Corporate < ApplicationRecord

  ## VALIDATIONS ##
  validates :name, presence: true

  ## ASSOCIATIONS ##
  belongs_to :client

end
