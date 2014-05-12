class User
  include Mongoid::Document

  field :password,     type: String
  field :device,       type: String
  field :verified,     type: Mongoid::Boolean
  field :token,        type: String
  field :token_count,  type: Integer
  field :token_device, type: String
  field :verified_at,  type: Date
  field :created_at,   type: Date
  field :facebook,     type: Hash # { uid: , oauth_token: , oauth_expires_at: , username: }
  field :twitter,      type: Hash # { uid: , oauth_token: , oauth_token_secret: , username: }

  def to_s
    self._id
  end
end
