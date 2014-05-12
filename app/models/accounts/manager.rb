class Manager < Account
  devise :confirmable, :recoverable, :async
  has_many :stores

  field :email,   type: String, default: ""
  field :owns,    type: Array
  field :primary, type: Mongoid::Boolean, default: true

  ## Confirmable
  field :confirmation_token,   type: String
  field :confirmed_at,         type: Time
  field :confirmation_sent_at, type: Time
  field :unconfirmed_email,    type: String # Only if using reconfirmable

  validates :email, uniqueness: true, presence: true
end
