class LoanApplication < ApplicationRecord

  enum status: {
    pending: 0,
    requested: 1,
    not_requested: 2,
    approved: 3,
    rejected: 4
  }

  ## ASSOCIATIONS ##
  belongs_to :client

  ##  INSTANCE METHODS ##
  def formatted_status
    if ["requested", "not_requested"].include?(status)
      status == "not_requested" ? "Nezažiadané" : "Požadované"
    else
      status.capitalize
    end
  end

end
