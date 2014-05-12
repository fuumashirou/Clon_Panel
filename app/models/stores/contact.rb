class Contact
  include Mongoid::Document
  embedded_in :store

  field :name,     type: String
  field :position, type: String
  field :email,    type: String
  field :phone,    type: String
  field :primary,  type: Mongoid::Boolean, default: false
  include Mongoid::Timestamps

  validates :name, presence: true
  validates :position, presence: true
  validates :email, presence: true, uniqueness: true
  validates :phone, presence: true

  before_destroy :check_if_primary
  before_validation :asign_as_primary, if: Proc.new { |a| a.store.new_record? }

  def asign_as_primary
    self.email = self.store.contacts.first.email
    self.primary = true
  end

  def check_if_primary
    self.primary ? false : true
  end

end
