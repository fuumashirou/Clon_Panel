class Store
  include Mongoid::Document
  belongs_to  :manager
  embeds_many :tables
  embeds_many :contacts
  embeds_many :categories
  embeds_many :selections
  embeds_one  :schedule
  embeds_one  :happy_hour
  embeds_many :payment_methods
  has_many :billings,   dependent: :destroy
  has_many :checkins,   dependent: :destroy
  has_many :items,      dependent: :destroy
  has_many :orders,     dependent: :destroy
  has_many :employees,  dependent: :destroy
  has_many :promotions, dependent: :destroy
  has_many :waiters,    dependent: :destroy
  has_many :songs,      dependent: :destroy

  CATEGORIES = %w(Pub Pub/Karaoke)
  CITIES = %w(Concepción)

  field :name,         type: String
  field :description,  type: String
  field :address,      type: String
  field :web,          type: String,  default: "http://"
  field :facebook,     type: String
  field :twitter,      type: String
  field :city,         type: String
  field :phone,        type: String
  field :loc,          type: Hash
  field :category,     type: String
  field :time_zone,    type: String
  field :currency,     type: String,  default: "CLP"
  field :payment,      type: Float,   default: 2.0
  field :billing_date, type: Integer, default: 28
  field :tipping,      type: Mongoid::Boolean, default: true
  field :tip_amount,   type: Float,   default: 10.0
  field :verified,     type: Mongoid::Boolean, default: false
  field :deleted,      type: Mongoid::Boolean, default: false
  field :active,       type: Mongoid::Boolean, default: true
  field :hidden,       type: Mongoid::Boolean, default: false
  field :waiter_token, type: String
  include Mongoid::Timestamps

  scope :not_deleted, where(deleted: false)

  validates :name,    presence: true
  validates :address, presence: true
  validates :city,    presence: true
  validates_associated :contacts, on: :create

  accepts_nested_attributes_for :employees, :contacts

  after_validation :complete
  after_create :add_to_manager
  before_destroy :remove_from_manager

  def complete
    if self.loc_changed? && !self.loc.nil?
      self.loc["lat"] = self.loc["lat"].to_f
      self.loc["lon"] = self.loc["lon"].to_f
    end
  end

  def change_mobile_token
    begin
      random_token = SecureRandom.hex(10)
    end while !Store.where(waiter_token: random_token).empty?
    self.set(waiter_token: random_token)
  end

  def to_s
    "#{self.name}"
  end

  def happy_hour?
    self.happy_hour && self.happy_hour.active == true ? true : false
  end

  def last_billing
    billings = self.billings
    if billings.empty?
      return false
    else
      today   = Time.now.day
      billing = billings.last
      return billing
    end
  end

  def coordinates
    "#{self.lat}, #{self.lon}"
  end

  def add_to_manager
    id = self._id.to_s
    self.manager.add_to_set(owns: id)
  end

  def remove_from_manager
    id = self._id.to_s
    self.manager.pull(owns: id)
  end

end
