class HhSchedules
  include Mongoid::Document
  embedded_in :happy_hour

  field :monday,    type: Hash
  field :tuesday,   type: Hash
  field :wednesday, type: Hash
  field :thursday,  type: Hash
  field :friday,    type: Hash
  field :saturday,  type: Hash
  field :sunday,    type: Hash
end
