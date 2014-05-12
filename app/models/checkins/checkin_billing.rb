class CheckinBilling
  include Mongoid::Document
  embedded_in :checkin
  embeds_many :items, class_name: "CheckinItem"

  field :billing_price, type: Float
  field :generated_by,  type: String
  field :generated_at,  type: Time
  field :paid,          type: Mongoid::Boolean
  field :payment_type,  type: String
end
