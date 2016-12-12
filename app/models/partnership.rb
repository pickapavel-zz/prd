class Partnership < ApplicationRecord

  ## ASSOCIATIONS ##
  belongs_to :client
  belongs_to :partner, class_name: 'Client'

end
