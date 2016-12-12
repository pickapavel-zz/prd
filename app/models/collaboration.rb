class Collaboration < ApplicationRecord

  ## ASSOCIATIONS ##
  belongs_to :client
  belongs_to :collaborator, class_name: 'User'

end
