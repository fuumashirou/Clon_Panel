class OrderItem
  include Mongoid::Document
  embedded_in :order

  field :name,     type: String
  field :quantity, type: Integer
  field :price,    type: Float
  field :comments, type: String
end
