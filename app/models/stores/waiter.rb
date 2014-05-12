class Waiter
  include Mongoid::Document
  belongs_to :store

  field :username, type: String
  field :allowed,  type: Mongoid::Boolean
  field :active,   type: Mongoid::Boolean
end
