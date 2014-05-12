class Employee < Account
  belongs_to :store

  field :primary, type: Mongoid::Boolean, default: false

  def email_required?
    false
  end
end
