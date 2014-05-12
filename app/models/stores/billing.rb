class Billing
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :store
  BILLING_DAYS = %w(1 7 14 21 28)

  field :gross_value, type: Float,   default: 0
  field :net_value,   type: Float,   default: 0
  field :from_date,   type: DateTime
  field :to_date,     type: DateTime
  field :payment,     type: Float
  field :paid,        type: Float,   default: false
  field :paid_at,     type: DateTime
  field :time,        type: Time
  field :method,      type: String
  field :url,         type: String
  field :mobile_url,  type: String
  field :verified,    type: Mongoid::Boolean, default: false
end
