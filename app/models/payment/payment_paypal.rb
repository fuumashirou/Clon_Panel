class PaymentKhipu < PaymentMethod
  field :client_id, type: String
  field :secret,    type: String

  before_validation :complete_defaults
  before_save :send_request

  def complete_defaults
    self.method = "paypal"
  end
end
