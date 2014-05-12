class SelectionItem
  include Mongoid::Document
  embedded_in :selection

  field :name,  type: String
  field :price, type: Float

  validates :name, presence: true

  after_create  :set_stock
  after_destroy :remove_stock
  before_validation :set_price_if_not_present

  def set_price_if_not_present
    self.price = self.price.nil? ? 0 : self.price
  end

  def set_stock
    if self.methods.include? "store"
      $redis.hset("Store:#{self.store._id}:SelectionItem", self._id, true)
    end
  end

  def remove_stock
    if self.methods.include? "store"
      $redis.hdel("Store:#{self.store._id}:SelectionItem", self._id)
    end
  end
end
