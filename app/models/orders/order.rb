class Order
  include Mongoid::Document
  belongs_to :store

  field :table_number, type: String
  field :checkin_id,   type: String
  field :ordered_by,   type: String
  field :ordered_at,   type: DateTime
  field :items,        type: Hash
  field :total,        type: Float
end
