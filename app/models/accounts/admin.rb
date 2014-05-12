class Admin < Account
  devise :confirmable, :async, :recoverable

  field :email, type: String, default: ""
  ## Confirmable
  field :confirmation_token,   type: String
  field :confirmed_at,         type: Time
  field :confirmation_sent_at, type: Time
  field :unconfirmed_email,    type: String # Only if using reconfirmable

  validates :email, uniqueness: true

  before_validation :complete

  def complete
    self.email = self.username
  end
end
