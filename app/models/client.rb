class Client < ApplicationRecord

  attr_accessor :partner_ic, :user_email

  ## VALIDATIONS ##
  validates :ic, presence: true
  validates :ic, length: { minimum: 6, maximum: 10, message: 'Minimálny počet číslic je 6', allow_blank: true},
                 numericality: { allow_blank: true, message: 'Zadajte prosím iba číslo' }

  ## ASSOCIATIONS ##
  belongs_to :user
  has_many :partnerships
  has_many :partners, through: :partnerships, class_name: 'Client'
  has_many :financial_indicators
  has_many :loan_applications
  has_many :corporates
  has_many :collaborations
  has_many :collaborators, through: :collaborations, class_name: 'User'

  ## ENUMERATORS ##
  enum segment_type: {
    micro: 0,
    small: 1,
    corporation: 2
  }

  ## CALLBACKS ##
  before_validation :assign_client_details, on: :create

  ## INSTANCE METHODS ##
  # returns register object
  def register
    @register ||= Client::Register.new(ic)
  end

  # returns gnosus object
  def gnosus
    @gnosus ||= Gnosus::Client.new(ic, 'sk')
  end

  # assigns attributes to client returned from registeruz
  def assign_register_details
    self.record_id = register.record_id
    if record_id.present?
      self.last_updated = register.last_updated
      self.data_source = register.data_source
      self.consolidated = register.consolidated
    else
      self.errors.add(:ic, "IČO nebylo možné dohledat")
      return false
    end
  end

  # assigns attributes to client returned from gnosus
  def assign_gnosus_details
    self.street ||= gnosus.street
    self.city ||= gnosus.city
    self.country ||= gnosus.country
    self.zip ||= gnosus.zip
    self.legal_form ||= gnosus.legal_form
    self.title ||= gnosus.title
    self.condition ||= gnosus.condition
    self.core_business ||= gnosus.core_business
    self.registration_date ||= gnosus.registration_date
    self.segment ||= gnosus.segment
    self.hard_ko_criteria ||= gnosus.hard_ko_criteria
    self.soft_ko_criteria ||= gnosus.soft_ko_criteria
  end

  def assign_client_details
    if validate_ic
      assign_register_details
      assign_gnosus_details if record_id.present?
      true
    end
  end

  # validates ic to return error on front end
  def validate_ic
    return (ic.present? && ic.to_i > 0 && ic.length >= 6 && ic.length <= 10) ? true : false
  end

  # for demo purpose '8206239085' is set as a fake id
  def fake?
    ic == '8206239085'
  end

end
