class Currency
  include Mongoid::Document
  field :currency, type: String

  validates :currency, presence: true, uniqueness: true

  before_save :capitalize

  def capitalize
    self.currency.upcase!
  end
end
