class Song
  include Mongoid::Document
  belongs_to :store

  field :artist,   type: String
  field :title,    type: String
  field :category, type: String
end
