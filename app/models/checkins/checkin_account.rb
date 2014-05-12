class CheckinAccount
  include Mongoid::Document
  embedded_in :checkin

  field :username,   type: String
  field :verified,   type: Mongoid::Boolean
  field :checked_at, type: DateTime
end
