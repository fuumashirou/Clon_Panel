class PaymentMethod
  include Mongoid::Document
  embedded_in :store

  field :default, type: Mongoid::Boolean, default: false
  field :method,  type: String

  before_save :set_default

  def set_default
    if self.store.payment_methods.size == 1
      self.default = true
    end
  end

end
