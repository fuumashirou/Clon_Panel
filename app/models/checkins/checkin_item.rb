class CheckinItem
  include Mongoid::Document
  embedded_in :billing, class_name: "CheckinBilling"

  field :name,     type: String
  field :quantity, type: Integer
  field :price,    type: Float
  include Mongoid::Timestamps
end
