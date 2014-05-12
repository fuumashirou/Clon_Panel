class Account
  include Mongoid::Document

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :validatable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, authentication_keys: [ :username ]

  ## Database authenticatable
  field :username,           type: String, default: ""
  field :auth_token,         type: String, default: -> { Digest::MD5.hexdigest("#{self.username}:#{Time.now}") }
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  ## Token authenticatable
  # field :authentication_token, type: String
  include Mongoid::Timestamps

  validates :username, uniqueness: true, presence: true

  def to_s
    "#{self.username}"
  end

  def is_admin?
    self._type == "Admin" ? true : false
  end

  def is_manager?
    self.class == Manager ? true : false
  end
end
