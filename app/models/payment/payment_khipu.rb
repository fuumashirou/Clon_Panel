class PaymentKhipu < PaymentMethod
  field :email,              type: String
  field :first_name,         type: String
  field :last_name,          type: String
  field :identifier,         type: String
  field :bussiness_category, type: String
  field :bussiness_name,     type: String
  field :phone,              type: String
  field :address_line_1,     type: String
  field :address_line_2,     type: String
  field :address_line_3,     type: String
  field :country_code,       type: String
  field :method,             type: String
  field :receiver_id,        type: String
  field :secret,             type: String

  before_validation :complete_defaults
  before_save :send_request

  validates_presence_of :email, :first_name, :last_name, :identifier, :bussiness_category, :bussiness_name, :phone, :address_line_1, :address_line_2, :address_line_3, :country_code, :method

  def complete_defaults
    self.country_code = "cl"
    self.method = "khipu"
  end

  def send_request
    data = Khipu::CreateReceiver.new({
        email:              self.email,
        first_name:         self.first_name,
        last_name:          self.last_name,
        identifier:         self.identifier,
        bussiness_category: self.bussiness_category,
        bussiness_name:     self.bussiness_name,
        phone:              self.phone,
        address_line_1:     self.address_line_1,
        address_line_2:     self.address_line_2,
        address_line_3:     self.address_line_3
      })
    if data.nil?
      return false
    else
      self.receiver_id = data.receiver_id
      self.secret = data.secret
      return true
    end
  end
end
