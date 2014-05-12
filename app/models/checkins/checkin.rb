class Checkin
  include Mongoid::Document
  embeds_many :billings, class_name: "CheckinBilling"
  has_many :orders, dependent: :destroy
  belongs_to :store
  belongs_to :table

  field :table_number, type: Integer
  field :arrive_at,    type: Time
  field :leave_at,     type: Time
  field :users,        type: Array
  field :total_price,  type: Float
  field :accounts,     type: Hash
end
